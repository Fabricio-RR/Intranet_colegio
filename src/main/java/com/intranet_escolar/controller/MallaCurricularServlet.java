package com.intranet_escolar.controller;

import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.dao.AperturaSeccionDAO;
import com.intranet_escolar.dao.DocenteDAO;
import com.intranet_escolar.dao.MallaCurricularDAO;
import com.intranet_escolar.model.DTO.AperturaSeccionDTO;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.intranet_escolar.model.entity.MallaCurricular;
import com.intranet_escolar.model.entity.Usuario;
import com.intranet_escolar.util.BitacoraUtil;
import com.intranet_escolar.util.SesionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Servlet de Malla Curricular – flujo idéntico a Matrícula
 *  ▸ el combo de años envía el NOMBRE del año (ej. “2026”)
 *  ▸ el servlet lo convierte a id antes de llamar al DAO
 *  ▸ creación exclusivamente MASIVA
 */
@WebServlet(name = "MallaCurricularServlet", urlPatterns = {"/malla-curricular"})
public class MallaCurricularServlet extends HttpServlet {

    /* ───────────── DAOs ───────────── */
    private final MallaCurricularDAO mallaDAO  = new MallaCurricularDAO();
    private final DocenteDAO         docenteDAO = new DocenteDAO();
    private final AperturaSeccionDAO aperturaDAO = new AperturaSeccionDAO();
    private final AnioLectivoDAO anioDAO = new AnioLectivoDAO();

    /*──────────────────────────────── GET ───────────────────────────────*/
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "ver";

        switch (action) {
            case "ver"                     -> resumenPorNivel(req, resp);
            case "nuevo"                   -> formularioCreacion(req, resp);
            case "detallePorNivel"         -> detallePorNivel(req, resp, false);
            case "detallePorNivelInactivas"-> detallePorNivel(req, resp, true);
            case "editar"                  -> formularioEdicion(req, resp);
            case "desactivarPorNivel"      -> desactivarPorNivel(req, resp);
            case "reactivarPorNivel"       -> reactivarPorNivel(req, resp);
            default                        -> resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    /*──────────────────────────────── POST ──────────────────────────────*/
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        System.out.println("[MallaCurricularServlet] action recibido = " + action);

        switch (action == null ? "" : action) {
            case "masiva"             -> crearMallaMasiva(req, resp);
            case "actualizarPorNivel" -> actualizarPorNivel(req, resp);
            case "desactivarPorNivel" -> desactivarPorNivel(req, resp);
            case "reactivarPorNivel"  -> reactivarPorNivel(req, resp);
            default                   -> doGet(req, resp);
        }
    }

    /* ==============================================================
                          VISTAS (GET)
       ==============================================================*/

    /** Resumen de mallas por nivel */
    private void resumenPorNivel(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String p = req.getParameter("anio");                   // llega id
        int idAnio = (p != null && !p.isEmpty())
                ? Integer.parseInt(p)
                : mallaDAO.obtenerAnioActivo();

        List<AnioLectivo> anios   = mallaDAO.obtenerAniosDisponibles();
        List<MallaCurricular> res = mallaDAO.listarResumenPorNivel(idAnio);

        List<MallaCurricular> activos   = new ArrayList<>();
        List<MallaCurricular> inactivos = new ArrayList<>();
        for (MallaCurricular r : res) {
            boolean todoInactivo = r.getTotalCursos() > 0 && r.getTotalCursos() == r.getTotalInactivos();
            (todoInactivo ? inactivos : activos).add(r);
        }

        req.setAttribute("anioActual", idAnio);
        req.setAttribute("anios", anios);
        req.setAttribute("nivelesActivos", activos);
        req.setAttribute("nivelesInactivos", inactivos);

        req.getRequestDispatcher("/views/malla/malla.jsp").forward(req, resp);
    }

    /** Formulario “Crear Malla” (flujo como Matrícula) */
    private void formularioCreacion(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        // Filtra solo años activos o en preparación
        List<AnioLectivo> aniosTodos = anioDAO.listarTodos();
        List<AnioLectivo> anios = new ArrayList<>();
        for (AnioLectivo a : aniosTodos) {
            if ("activo".equalsIgnoreCase(a.getEstado()) || "preparacion".equalsIgnoreCase(a.getEstado())) {
                anios.add(a);
            }
        }

        String param = req.getParameter("anio");
        final String anioNombreSel = (param != null && !param.isEmpty())
                ? param
                : elegirNombreAnioPorDefecto(anios);

        int idAnioSel = anios.stream()
                .filter(a -> a.getNombre().equals(anioNombreSel))
                .map(AnioLectivo::getIdAnioLectivo)
                .findFirst()
                .orElse(0);

        // === Cambia solo esta línea: ===
        //List<AperturaSeccionDTO> aperturas = aperturaDAO.obtenerAperturasSeccionPorAnio(idAnioSel);
        List<AperturaSeccionDTO> aperturas = new ArrayList<>();
        for (AnioLectivo anio : anios) {
            aperturas.addAll(aperturaDAO.obtenerAperturasSeccionPorAnio(anio.getIdAnioLectivo()));
        }

        req.setAttribute("aniosLectivos",   anios);
        req.setAttribute("anioLectivoSel",  anioNombreSel);
        req.setAttribute("idAnioSel",       idAnioSel);
        req.setAttribute("aperturasSeccion",aperturas);
        req.setAttribute("cursos",          mallaDAO.listarCursos());
        req.setAttribute("docentes",        docenteDAO.listarTodos());

        req.getRequestDispatcher("/views/malla/crear-malla.jsp").forward(req, resp);
    }

    /** Selecciona año: Preparación > Activo > primero */
    private String elegirNombreAnioPorDefecto(List<AnioLectivo> anios) {
        Optional<AnioLectivo> prep = anios.stream()
                .filter(a -> "PREPARACION".equalsIgnoreCase(a.getEstado()))
                .findFirst();
        if (prep.isPresent()) return prep.get().getNombre();

        Optional<AnioLectivo> act = anios.stream()
                .filter(a -> "ACTIVO".equalsIgnoreCase(a.getEstado()))
                .findFirst();
        if (act.isPresent()) return act.get().getNombre();

        return anios.isEmpty() ? "" : anios.get(0).getNombre();
    }

    /** Detalle de nivel (activos o inactivos) */
    private void detallePorNivel(HttpServletRequest req, HttpServletResponse resp, boolean inactivas)
            throws ServletException, IOException {

        int idNivel = Integer.parseInt(req.getParameter("idNivel"));
        int idAnio  = Integer.parseInt(req.getParameter("anio"));

        List<MallaCurricular> detalle = inactivas
                ? mallaDAO.listarDetallePorNivelInactivas(idNivel, idAnio)
                : mallaDAO.listarDetallePorNivel(idNivel, idAnio);

        req.setAttribute("detalleMalla", detalle);
        req.getRequestDispatcher("/views/malla/detalle.jsp").forward(req, resp);
    }

    /** Formulario edición */
    private void formularioEdicion(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int idNivel = Integer.parseInt(req.getParameter("idNivel"));
        int idAnio  = Integer.parseInt(req.getParameter("anio"));

        req.setAttribute("detalleMalla",
                mallaDAO.listarDetallePorNivel(idNivel, idAnio));
        req.setAttribute("docentes", docenteDAO.listarTodos());

        req.getRequestDispatcher("/views/malla/editar-malla.jsp").forward(req, resp);
    }

    /* ==============================================================
                      OPERACIONES (POST / AJAX)
       ==============================================================*/

    /** Crear malla MASIVA */
    private void crearMallaMasiva(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            int idApertura   = Integer.parseInt(req.getParameter("idAperturaSeccion"));
            int idAnioLectivo= Integer.parseInt(req.getParameter("idAnioLectivo"));

            String[] idCursos   = req.getParameterValues("idCurso[]");
            String[] idDocentes = req.getParameterValues("idDocente[]");
            String[] ordenes    = req.getParameterValues("orden[]");
            String[] activos    = req.getParameterValues("activo[]");

            boolean ok = true;
            for (int i = 0; i < idCursos.length; i++) {
                MallaCurricular m = new MallaCurricular();
                m.setIdAperturaSeccion(idApertura);
                m.setIdCurso   (Integer.parseInt(idCursos[i]));
                m.setIdDocente(Integer.parseInt(idDocentes[i]));
                m.setOrden     (Integer.parseInt(ordenes[i]));
                m.setActivo    ("1".equals(activos[i]));
                ok &= mallaDAO.crear(m);
            }

            Usuario u = SesionUtil.getUsuarioLogueado(req);
            if (ok && u != null) {
                BitacoraUtil.registrar(u.getIdUsuario(), "MallaCurricular",
                        String.format("Creó malla MASIVA (apertura=%d, año=%d)", idApertura, idAnioLectivo));
            }

            String base = req.getContextPath() + "/malla-curricular?success=1&op=add";
            resp.sendRedirect(ok ? base : base.replace("success=1", "error=1"));

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                    + "/malla?error=Error al crear la malla masiva");
        }
    }

    /** Actualizar por nivel (desde formulario edición) */
    private void actualizarPorNivel(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        
        String[] ids = req.getParameterValues("idMalla[]");
        boolean  ok  = true;
        Usuario  usr = SesionUtil.getUsuarioLogueado(req);

        if (ids != null) {
            for (String s : ids) {
                int idMalla = Integer.parseInt(s);

                int idDocente = Integer.parseInt(
                        req.getParameter("idDocente_" + idMalla));
                int orden     = Integer.parseInt(
                        req.getParameter("orden_"    + idMalla));
                String[] activos = req.getParameterValues("activo_" + idMalla);
                boolean activo = activos != null && "1".equals(activos[activos.length - 1]);

                MallaCurricular m = new MallaCurricular();
                m.setIdMalla  (idMalla);
                m.setIdDocente(idDocente);
                m.setOrden    (orden);
                m.setActivo   (activo);

                ok &= mallaDAO.actualizar(m);

                if (usr != null) {
                    BitacoraUtil.registrar(usr.getIdUsuario(), "MallaCurricular",
                            String.format("Editó id_malla=%d, docente=%d, orden=%d, activo=%s",
                                    idMalla, idDocente, orden, activo ? "1" : "0"));
                }
            }
        }

        resp.setContentType("application/json");
        if (ok) {
            resp.getWriter().write("{\"mensaje\":\"Actualizado correctamente\"}");
        } else {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"mensaje\":\"Error al actualizar\"}");
        }
    }

    /** Desactivar por nivel */
    private void desactivarPorNivel(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int idNivel = Integer.parseInt(req.getParameter("idNivel"));
        int idAnio  = Integer.parseInt(req.getParameter("anio"));

        boolean ok = mallaDAO.desactivarPorNivel(idNivel, idAnio);

        if (ok) registrarBit(req, "Desactivó", idNivel, idAnio);
        responderJson(resp, ok, "Malla desactivada.");
    }

    /** Reactivar por nivel */
    private void reactivarPorNivel(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int idNivel = Integer.parseInt(req.getParameter("idNivel"));
        int idAnio  = Integer.parseInt(req.getParameter("anio"));

        boolean ok = mallaDAO.reactivarPorNivel(idNivel, idAnio);

        if (ok) registrarBit(req, "Reactivó", idNivel, idAnio);
        responderJson(resp, ok, "Malla reactivada.");
    }

    /* ---- util bitácora + respuesta JSON ---- */
    private void registrarBit(HttpServletRequest req, String acc, int nivel, int anio) {
        Usuario u = SesionUtil.getUsuarioLogueado(req);
        if (u != null) {
            BitacoraUtil.registrar(u.getIdUsuario(), "MallaCurricular",
                    String.format("%s malla nivel %d, año %d", acc, nivel, anio));
        }
    }
    private void responderJson(HttpServletResponse resp, boolean ok, String msg)
            throws IOException {

        resp.setContentType("application/json");
        if (ok) {
            resp.getWriter().write("{\"mensaje\":\"" + msg + "\"}");
        } else {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"mensaje\":\"No se pudo completar la operación\"}");
        }
    }

    /*--------------------------------------------------------*/
    @Override public String getServletInfo() {
        return "Servlet de Malla Curricular – año por nombre, creación masiva";
    }
}
