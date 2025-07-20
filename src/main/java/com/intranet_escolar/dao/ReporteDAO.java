package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.DTO.ReportePublicadoDTO;
import com.intranet_escolar.model.entity.*;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.xwpf.usermodel.ParagraphAlignment;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTShd;

public class ReporteDAO {

    // ***** CONSTANTES *****
    private static final int SECUNDARIA_NIVEL_ID = 3;
    private static final String NOMBRE_COLEGIO    = "Colegio Peruano Chino Diez de Octubre";
    private static final String RUTA_LOGO         = "/assets/img/EscudoCDO.png";

    // ***** DAOs AUXILIARES *****
    private final AlumnoDAO      alumnoDAO     = new AlumnoDAO();
    private final PeriodoDAO     periodoDAO    = new PeriodoDAO();
    private final AcademicoDAO   academicoDAO  = new AcademicoDAO();
    private final AnioLectivoDAO anioDAO       = new AnioLectivoDAO();

    // ========== 1. Asistencia (mensual) ==========
    public byte[] generarAsistencia(int anioId, int periodoId,
                                    int nivelId, int gradoId, int seccionId,
                                    String alumnoFiltro, String formato) {
        String[] headers = {
            "Nº", "Apellidos y Nombres",
            "Asistencias", "Tardanzas", "Tardanzas Justificadas",
            "Faltas", "Faltas Justificadas"
        };
        List<String[]> data = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_reporte_asistencia(?,?,?,?,?)}")) {

            cs.setInt(1, anioId);
            cs.setInt(2, periodoId);
            cs.setInt(3, nivelId);
            cs.setInt(4, gradoId);
            cs.setInt(5, seccionId);

            try (ResultSet rs = cs.executeQuery()) {
                int idx;
                while (rs.next()) {
                    String cod = rs.getString("codigo_matricula");
                    if (alumnoFiltro == null || alumnoFiltro.isEmpty() || alumnoFiltro.equals(cod)) {
                        idx = 1;
                        data.add(new String[]{
                            String.valueOf(idx++),
                            rs.getString("apellidos") + " " + rs.getString("nombres"),
                            rs.getString("asistencias"),
                            rs.getString("tardanzas"),
                            rs.getString("tardanzas_justificadas"),
                            rs.getString("faltas"),
                            rs.getString("faltas_justificadas")
                        });
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error generando reporte de asistencia", e);
        }

        return dispatchFormatVertical(
            formato,
            headers, data,
            "Asistencia - Resumen por Alumno",
            nombrePeriodo(anioId, periodoId),
            anioDAO.obtenerNombrePorId(anioId),
            obtenerNombreNivel(nivelId),
            obtenerNombreGrado(gradoId),
            obtenerNombreSeccion(seccionId), 
            ""
        );
    }

    // ========== 2. Rendimiento Académico (mensual) ==========
    public byte[] generarRendimiento(int anioId, int periodoId,
                                     int nivelId, int gradoId, int seccionId,
                                     String alumnoFiltro, String formato) {
        String[] headers = {"Apellidos", "Nombres", "Promedio", "Condición"};
        List<String[]> data = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_reporte_rendimiento(?,?,?,?,?)}")) {

            cs.setInt(1, anioId);
            cs.setInt(2, periodoId);
            cs.setInt(3, nivelId);
            cs.setInt(4, gradoId);
            cs.setInt(5, seccionId);

            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    data.add(new String[]{
                        rs.getString("apellidos"),
                        rs.getString("nombres"),
                        rs.getString("promedio"),
                        rs.getString("condicion")
                    });
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error generando reporte de rendimiento", e);
        }

        return dispatchFormat(
            formato,
            headers, data,
            "Rendimiento",
            nombrePeriodo(anioId, periodoId),
            anioDAO.obtenerNombrePorId(anioId),
            obtenerNombreNivel(nivelId),
            obtenerNombreGrado(gradoId),
            obtenerNombreSeccion(seccionId)
        );
    }

    // ========== 3. Consolidado de Notas ==========
    public byte[] generarConsolidado(int anioId, int periodoId,
                                     int nivelId, int gradoId, int seccionId,
                                     String tipoNota, String alumnoFiltro, String formato) {
        try {
            ConsolidadoData cd = construirTablaNotas(
                anioId, periodoId, seccionId,
                nivelId, gradoId, tipoNota, alumnoFiltro
            );
            return dispatchFormat(
                formato,
                cd.headers, cd.filas,
                "Consolidado",
                nombrePeriodo(anioId, periodoId),
                anioDAO.obtenerNombrePorId(anioId),
                obtenerNombreNivel(nivelId),
                obtenerNombreGrado(gradoId),
                obtenerNombreSeccion(seccionId)
            );
        } catch (SQLException e) {
            throw new RuntimeException("Error generando consolidado", e);
        }
    }

    // ========== 4. Libreta de Notas Bimestral ==========
    public byte[] generarLibretaBimestral(int anioId, int periodoId,
                                          int nivelId, int gradoId, int seccionId,
                                          String tipoNota, String alumnoFiltro, String formato) {
        String[] headers = {"Nº", "Curso", "Nota"};
        List<String[]> data = new ArrayList<>();
        String nombreAlumno = "";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_reporte_libreta(?,?,?,?,?,?)}")) {

            cs.setInt(1, anioId);
            cs.setInt(2, periodoId);
            cs.setInt(3, nivelId);
            cs.setInt(4, gradoId);
            cs.setInt(5, seccionId);
            if (alumnoFiltro != null && !alumnoFiltro.isEmpty()) {
                // Si vino un ID de alumno, lo pasamos como entero
                cs.setInt(6, Integer.parseInt(alumnoFiltro));
            } else {
                // Si no hay filtro, enviamos NULL (no cadena vacía)
                cs.setNull(6, java.sql.Types.INTEGER);
            }


            try (ResultSet rs = cs.executeQuery()) {
                int idx = 1;
                while (rs.next()) {
                    if (nombreAlumno.isEmpty()) {
                        nombreAlumno = rs.getString("apellidos") + " " + rs.getString("nombres");
                    }

                    // --- Aquí viene el cambio ---
                    Double notaNum = rs.getObject("nota_bimestre", Double.class);
                    String notaStr;
                    if (notaNum == null) {
                        notaStr = "";
                    } else if (tipoNota.equalsIgnoreCase("numerico")) {
                        // Formato numérico solo si hay valor
                        notaStr = String.format(Locale.US, "%.2f", notaNum);
                    } else {
                        // Convertir a letra solo si hay valor
                        notaStr = convertirANotaLetra(notaNum);
                    }
                    // --- fin del cambio ---

                    data.add(new String[]{
                        String.valueOf(idx++),
                        rs.getString("curso"),
                        notaStr
                    });
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error generando libreta bimestral", e);
        }

        return dispatchFormatVertical(
            formato, headers, data, "Libreta Bimestral",
            nombrePeriodo(anioId, periodoId),
            anioDAO.obtenerNombrePorId(anioId),
            obtenerNombreNivel(nivelId),
            obtenerNombreGrado(gradoId),
            obtenerNombreSeccion(seccionId),
            nombreAlumno
        );
    }
    
    // ========== 5. Libreta de Notas General ==========
    public byte[] generarLibretaGeneral(int anioId,
                                    int nivelId, int gradoId, int seccionId,
                                    String tipoNota, String alumnoFiltro, String formato) {
        String[] headers = {
            "Nº", "Curso",
            "I", "II", "III", "IV", "Promedio Anual"
        };
        List<String[]> data = new ArrayList<>();
        String nombreAlumno = "";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_reporte_libreta_general(?,?,?,?,?)}")) {

            cs.setInt(1, anioId);
            cs.setInt(2, nivelId);
            cs.setInt(3, gradoId);
            cs.setInt(4, seccionId);
            if (alumnoFiltro != null && !alumnoFiltro.isEmpty()) {
                // Si vino un ID de alumno, lo pasamos como entero
                cs.setInt(5, Integer.parseInt(alumnoFiltro));
            } else {
                // Si no hay filtro, enviamos NULL (no cadena vacía)
                cs.setNull(6, java.sql.Types.INTEGER);
            }


            try (ResultSet rs = cs.executeQuery()) {
                int idx = 1;
                while (rs.next()) {
                    if (nombreAlumno.isEmpty()) {
                        nombreAlumno = rs.getString("apellidos") + " " + rs.getString("nombres");
                    }

                    Double n1 = rs.getObject("nota_I", Double.class);
                    Double n2 = rs.getObject("nota_II", Double.class);
                    Double n3 = rs.getObject("nota_III", Double.class);
                    Double n4 = rs.getObject("nota_IV", Double.class);
                    Double prom = rs.getObject("promedio_anual", Double.class);
                    
                    String notaI   = (n1 == null)   ? "" : (tipoNota.equalsIgnoreCase("letra") ? convertirANotaLetra(n1)   : String.format(Locale.US, "%.2f", n1));
                    String notaII  = (n2 == null)   ? "" : (tipoNota.equalsIgnoreCase("letra") ? convertirANotaLetra(n2)   : String.format(Locale.US, "%.2f", n2));
                    String notaIII = (n3 == null)   ? "" : (tipoNota.equalsIgnoreCase("letra") ? convertirANotaLetra(n3)   : String.format(Locale.US, "%.2f", n3));
                    String notaIV  = (n4 == null)   ? "" : (tipoNota.equalsIgnoreCase("letra") ? convertirANotaLetra(n4)   : String.format(Locale.US, "%.2f", n4));
                    String notaProm= (prom == null) ? "" : (tipoNota.equalsIgnoreCase("letra") ? convertirANotaLetra(prom) : String.format(Locale.US, "%.2f", prom));


                    data.add(new String[]{
                        String.valueOf(idx++),
                        rs.getString("curso"),
                        notaI, notaII, notaIII, notaIV, notaProm
                    });
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error generando libreta general", e);
        }

        return dispatchFormatVertical(
            formato,
            headers, data,
            "Libreta General",
            "General",
            anioDAO.obtenerNombrePorId(anioId),
            obtenerNombreNivel(nivelId),
            obtenerNombreGrado(gradoId),
            obtenerNombreSeccion(seccionId),
            nombreAlumno
        );
    }


    // ========== 6. Progreso del Alumno Mensual ==========
    public byte[] generarProgreso(int anioId, int periodoId,
                                  int nivelId, int gradoId, int seccionId,
                                  String alumnoIdStr, String tipoNota, String formato) {

        String[] headers = {"Nº", "Curso", "Nota"};
        List<String[]> data = new ArrayList<>();
        String nombreAlumno = "";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_reporte_progreso(?,?,?,?,?,?)}")) {

            // 1) convertir SOLO el ID de alumno
            int alumnoId = Integer.parseInt(alumnoIdStr);

            cs.setInt(1, anioId);
            cs.setInt(2, periodoId);
            cs.setInt(3, nivelId);
            cs.setInt(4, gradoId);
            cs.setInt(5, seccionId);
            cs.setInt(6, alumnoId);

            // 2) ejecutar y leer
            try (ResultSet rs = cs.executeQuery()) {
                int idx = 1;
                while (rs.next()) {
                    if (nombreAlumno.isEmpty()) {
                        nombreAlumno = rs.getString("apellidos") + ", " + rs.getString("nombres");
                    }
                    String notaRaw = rs.getString("nota");
                    String notaStr;
                    if (notaRaw == null || notaRaw.trim().isEmpty()) {
                        notaStr = "";
                    } else if ("SN".equalsIgnoreCase(notaRaw)) {
                        notaStr = "SN";
                    } else if ("letra".equalsIgnoreCase(tipoNota)) {
                        try {
                            notaStr = convertirANotaLetra(Double.parseDouble(notaRaw));
                        } catch (NumberFormatException ex) {
                            notaStr = notaRaw;
                        }
                    } else {
                        notaStr = notaRaw;
                    }
                    data.add(new String[]{
                        String.valueOf(idx++),
                        rs.getString("curso"),
                        notaStr
                    });
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error generando reporte de progreso", e);
        }

        // 3) dispatch al formato deseado
        return dispatchFormatVertical(
            formato,
            headers, data,
            "Progreso del Alumno",
            nombrePeriodo(anioId, periodoId),
            anioDAO.obtenerNombrePorId(anioId),
            obtenerNombreNivel(nivelId),
            obtenerNombreGrado(gradoId),
            obtenerNombreSeccion(seccionId),
            nombreAlumno
        );
    }

    // ========== Bloque ZIP de todos los alumnos ==========
    public byte[] generarBloqueZip(int anioId, String periodoStr,
                                   String nivelName, String gradoName, String seccionName,
                                   String tipoReporte, String tipoNota,
                                   String alumnoFiltro, String formato)
        throws IOException, SQLException {

        // 1) Resolver IDs de nivel, grado y sección
        int idNivel   = lookupId("nivel", nivelName);
        int idGrado   = lookupId("grado", gradoName);
        int idSeccion = lookupId("seccion", seccionName);

        // 2) Parsear periodo cuando sea necesario
        Integer periodoId = null;
        String key = tipoReporte == null ? "" : tipoReporte.replaceAll("_", "").toLowerCase();
        // Solo algunos reportes permiten sección única
        boolean sectionLevel = Arrays.asList("asistencia", "rendimiento", "consolidado", "libretageneral").contains(key);
        if (!"libretageneral".equals(key)) {
            if (periodoStr == null || periodoStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Para el reporte '" + tipoReporte + "' es obligatorio indicar el periodo.");
            }
            try {
                periodoId = Integer.parseInt(periodoStr);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Periodo inválido: '" + periodoStr + "'.", e);
            }
        }

        // 3) Preparar colecciones para los bytes y nombres
        List<byte[]> archivos = new ArrayList<>();
        List<String> nombres  = new ArrayList<>();
        String ext = formato.equalsIgnoreCase("excel") ? "xlsx"
                   : formato.equalsIgnoreCase("word")  ? "docx"
                                                       : "pdf";

        // 4) Si no hay filtro de alumno y el reporte admite sección completa
        if ((alumnoFiltro == null || alumnoFiltro.trim().isEmpty()) && sectionLevel) {
            byte[] rpt;
            String fileName = nivelName + "_" + gradoName + "_" + seccionName + "." + ext;
            switch (key) {
                case "asistencia":
                    rpt = generarAsistencia(anioId, periodoId, idNivel, idGrado, idSeccion, "", formato);
                    break;
                case "rendimiento":
                    rpt = generarRendimiento(anioId, periodoId, idNivel, idGrado, idSeccion, "", formato);
                    break;
                case "consolidado":
                    rpt = generarConsolidado(anioId, periodoId, idNivel, idGrado, idSeccion, tipoNota, "", formato);
                    break;
                case "libretageneral":
                    rpt = generarLibretaGeneral(anioId, idNivel, idGrado, idSeccion, tipoNota, "", formato);
                    break;
                default:
                    // Nunca llega aquí porque sectionLevel evita otros keys
                    throw new IllegalArgumentException("Tipo de reporte no soporta sección completa: '" + tipoReporte + "'.");
            }
            archivos.add(rpt);
            nombres.add(fileName);
        }

        // 5) Generar por alumno individual para todos los casos restantes
        // (o filtro explícito, o reportes que requieren alumno)
        List<Alumno> alumnos = alumnoDAO.listarMatriculadosPorFiltros(anioId, idNivel, idGrado, idSeccion);
        for (Alumno al : alumnos) {
            String alumnoIdStr = String.valueOf(al.getIdAlumno());
            byte[] rpt = null;
            String saneApellido = al.getApellidos().replaceAll("\\s+", "_");
            String saneNombre   = al.getNombres().replaceAll("\\s+", "_");
            String fileName = saneApellido + "_" + saneNombre + "." + ext;
            switch (key) {
                case "asistencia":
                    // Si ya generamos sección entera, skip individual
                    if ((alumnoFiltro == null || alumnoFiltro.isEmpty()) && sectionLevel) break;
                    rpt = generarAsistencia(anioId, periodoId, idNivel, idGrado, idSeccion, alumnoIdStr, formato);
                    break;
                case "rendimiento":
                    if ((alumnoFiltro == null || alumnoFiltro.isEmpty()) && sectionLevel) break;
                    rpt = generarRendimiento(anioId, periodoId, idNivel, idGrado, idSeccion, alumnoIdStr, formato);
                    break;
                case "consolidado":
                    if ((alumnoFiltro == null || alumnoFiltro.isEmpty()) && sectionLevel) break;
                    rpt = generarConsolidado(anioId, periodoId, idNivel, idGrado, idSeccion, tipoNota, alumnoIdStr, formato);
                    break;
                case "libretabimestral":
                    rpt = generarLibretaBimestral(anioId, periodoId, idNivel, idGrado, idSeccion, tipoNota, alumnoIdStr, formato);
                    break;
                case "libretageneral":
                    if ((alumnoFiltro == null || alumnoFiltro.isEmpty()) && sectionLevel) break;
                    rpt = generarLibretaGeneral(anioId, idNivel, idGrado, idSeccion, tipoNota, alumnoIdStr, formato);
                    break;
                case "progreso":
                    rpt = generarProgreso(anioId, periodoId, idNivel, idGrado, idSeccion, alumnoIdStr, tipoNota, formato);
                    break;
                default:
                    // Ignorar tipos desconocidos
                    continue;
            }
            archivos.add(rpt);
            nombres.add(fileName);
        }

        // 6) Empaquetar el ZIP y devolver
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
             ZipOutputStream zos     = new ZipOutputStream(baos)) {
            for (int i = 0; i < archivos.size(); i++) {
                zos.putNextEntry(new ZipEntry(nombres.get(i)));
                zos.write(archivos.get(i));
                zos.closeEntry();
            }
            zos.finish();
            return baos.toByteArray();
        }
    }

    // ========== Historial de reportes publicados ==========
    public List<ReportePublicadoDTO> listarReportesPublicados(Integer anio) {
        List<ReportePublicadoDTO> lista = new ArrayList<>();
        String sql = "SELECT id_reporte, tipo, periodo, nivel, grado, seccion, fecha_publicacion,"
                   + " publicado_por, archivo, anio FROM reporte_publicado "
                   + "WHERE (? IS NULL OR anio=?) ORDER BY fecha_publicacion DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (anio != null) {
                ps.setInt(1, anio);
                ps.setInt(2, anio);
            } else {
                ps.setNull(1, Types.INTEGER);
                ps.setNull(2, Types.INTEGER);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReportePublicadoDTO r = new ReportePublicadoDTO();
                    r.setIdReporte(rs.getInt("id_reporte"));
                    r.setTipoReporte(rs.getString("tipo"));
                    r.setPeriodo(rs.getString("periodo"));
                    r.setNivel(rs.getString("nivel"));
                    r.setGrado(rs.getString("grado"));
                    r.setSeccion(rs.getString("seccion"));
                    r.setFechaPublicacion(rs.getTimestamp("fecha_publicacion"));
                    r.setPublicadoPor(rs.getString("publicado_por"));
                    r.setArchivo(rs.getString("archivo"));
                    r.setAnio(rs.getString("anio"));
                    lista.add(r);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error listando reportes publicados", e);
        }
        return lista;
    }

    // ========== Dispatcher de formato ==========
    private byte[] dispatchFormat(String formato,
                                  String[] headers,
                                  List<String[]> data,
                                  String titulo,
                                  String periodoTexto,
                                  String anioTexto,
                                  String nivelTexto,
                                  String gradoTexto,
                                  String seccionTexto) {
        if ("excel".equalsIgnoreCase(formato)) {
            return generarExcel(headers, data,
                titulo, periodoTexto, anioTexto,
                nivelTexto, gradoTexto, seccionTexto);
        } else {
            return generarPDF(headers, data,
                titulo, periodoTexto, anioTexto,
                nivelTexto, gradoTexto, seccionTexto);
        }
    }
    // ========== Dispatcher especial para vertical, agregando nombre de alumno ==========
    private byte[] dispatchFormatVertical(String formato,String[] headers,List<String[]> data,String titulo,String periodoTexto,String anioTexto,String nivelTexto,String gradoTexto,String seccionTexto,String nombreAlumno) {
        if ("excel".equalsIgnoreCase(formato)) {
            return generarExcelVertical(headers, data,
                titulo, periodoTexto, anioTexto,
                nivelTexto, gradoTexto, seccionTexto, nombreAlumno);
        } else {
            return generarPDFVertical(headers, data,
                titulo, periodoTexto, anioTexto,
                nivelTexto, gradoTexto, seccionTexto, nombreAlumno);
        }
    }

    // ========== Generadores de archivo (PDF / Excel / Word) ==========
    private byte[] generarPDF(String[] headers,
                          List<String[]> data,
                          String titulo,
                          String periodoTexto,
                          String anioTexto,
                          String nivelTexto,
                          String gradoTexto,
                          String seccionTexto) {
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            Document doc = new Document(PageSize.A4.rotate(), 36,36,72,36);
            PdfWriter.getInstance(doc, baos);
            doc.open();

            // Logo y cabecera
            try {
                Image logo = Image.getInstance(getClass().getResource(RUTA_LOGO));
                logo.scaleToFit(80, 80);
                logo.setAbsolutePosition(36, doc.getPageSize().getHeight() - 100);
                doc.add(logo);
            } catch (Exception ignored) {}

            Paragraph esc = new Paragraph(
                NOMBRE_COLEGIO,
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK)
            );
            esc.setAlignment(Element.ALIGN_CENTER);
            doc.add(esc);

            Paragraph sub = new Paragraph(
                String.format("%s – %s / Año %s", titulo, periodoTexto, anioTexto),
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, BaseColor.DARK_GRAY)
            );
            sub.setAlignment(Element.ALIGN_CENTER);
            doc.add(sub);
            doc.add(Chunk.NEWLINE);

            Paragraph info = new Paragraph(
                String.format("Nivel: %s   Grado: %s   Sección: %s", nivelTexto, gradoTexto, seccionTexto),
                FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.DARK_GRAY)
            );
            info.setAlignment(Element.ALIGN_CENTER);
            doc.add(info);
            doc.add(Chunk.NEWLINE);

            Paragraph fecha = new Paragraph(
                "Fecha: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 8)
            );
            fecha.setAlignment(Element.ALIGN_RIGHT);
            doc.add(fecha);
            doc.add(Chunk.NEWLINE);

            PdfPTable tbl = new PdfPTable(headers.length);
            tbl.setWidthPercentage(100);
            // Establecer anchos adaptados a headers
            float[] columnWidths = new float[headers.length];
            for (int i = 0; i < headers.length; i++) {
                String h = headers[i].trim().toLowerCase();

                if (h.equals("nº") || h.equals("n°") || h.equals("nro") || h.equals("no")) {
                    columnWidths[i] = 1f;
                } else if (h.contains("apellidos") || h.contains("nombres")) {
                    columnWidths[i] = 5f;
                } else {
                    columnWidths[i] = 2f;
                }
            }
            tbl.setWidths(columnWidths);

            BaseColor headerBg = new BaseColor(52, 73, 94);
            BaseColor rowAlt   = new BaseColor(236,240,241);
            boolean alternate  = false;

            // Cabeceras
            for (String h : headers) {
                PdfPCell c = new PdfPCell(new Phrase(h, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE)));
                c.setBackgroundColor(headerBg);
                c.setHorizontalAlignment(Element.ALIGN_CENTER);
                c.setPadding(6);
                tbl.addCell(c);
            }

            // Datos o fila vacía
            if (data.isEmpty()) {
                PdfPCell c = new PdfPCell(new Phrase("Sin registros",
                    FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 10, BaseColor.GRAY)));
                c.setColspan(headers.length);
                c.setHorizontalAlignment(Element.ALIGN_CENTER);
                c.setPadding(10);
                tbl.addCell(c);
            } else {
                for (String[] row : data) {
                    BaseColor bg = alternate ? rowAlt : BaseColor.WHITE;
                    for (String v : row) {
                        PdfPCell c = new PdfPCell(new Phrase(v, FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.BLACK)));
                        c.setBackgroundColor(bg);
                        c.setHorizontalAlignment(Element.ALIGN_CENTER);
                        c.setPadding(4);
                        tbl.addCell(c);
                    }
                    alternate = !alternate;
                }
            }

            doc.add(tbl);
            doc.close();
            return baos.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Error generando PDF", e);
        }
    }

    
    private byte[] generarPDFVertical(String[] headers, List<String[]> data, String titulo, String periodoTexto, String anioTexto, String nivelTexto, String gradoTexto, String seccionTexto, String nombreAlumno) {
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            Document doc = new Document(PageSize.A4, 36,36,72,36);
            PdfWriter.getInstance(doc, baos);
            doc.open();

            try {
                Image logo = Image.getInstance(getClass().getResource(RUTA_LOGO));
                logo.scaleToFit(80, 80);
                logo.setAbsolutePosition(36, doc.getPageSize().getHeight() - 100);
                doc.add(logo);
            } catch (Exception ignored) {}

            Paragraph esc = new Paragraph(
                NOMBRE_COLEGIO,
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK)
            );
            esc.setAlignment(Element.ALIGN_CENTER);
            doc.add(esc);

            Paragraph sub = new Paragraph(
                String.format("%s – %s / Año %s", titulo, periodoTexto, anioTexto),
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, BaseColor.DARK_GRAY)
            );
            sub.setAlignment(Element.ALIGN_CENTER);
            doc.add(sub);
            if (nombreAlumno != null && !nombreAlumno.trim().isEmpty()) {
                Paragraph alumno = new Paragraph(
                    "Alumno: " + nombreAlumno,
                    FontFactory.getFont(FontFactory.HELVETICA_BOLD, 13, BaseColor.BLACK)
                );
                alumno.setAlignment(Element.ALIGN_CENTER);
                doc.add(alumno);
            }


            doc.add(Chunk.NEWLINE);

            Paragraph info = new Paragraph(
                String.format("Nivel: %s   Grado: %s   Sección: %s", nivelTexto, gradoTexto, seccionTexto),
                FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.DARK_GRAY)
            );
            info.setAlignment(Element.ALIGN_CENTER);
            doc.add(info);
            doc.add(Chunk.NEWLINE);

            Paragraph fecha = new Paragraph(
                "Fecha: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 8)
            );
            fecha.setAlignment(Element.ALIGN_RIGHT);
            doc.add(fecha);
            doc.add(Chunk.NEWLINE);

            PdfPTable tbl = new PdfPTable(headers.length);
            tbl.setWidthPercentage(100);
            // Establecer anchos adaptados a headers
            float[] columnWidths = new float[headers.length];
            for (int i = 0; i < headers.length; i++) {
                String h = headers[i].trim().toLowerCase();

                if (h.equals("nº") || h.equals("n°") || h.equals("nro") || h.equals("no")) {
                    columnWidths[i] = 1f;
                } else if (h.contains("apellidos") || h.contains("nombres")) {
                    columnWidths[i] = 5f;
                } else {
                    columnWidths[i] = 2f;
                }
            }
            tbl.setWidths(columnWidths);

            BaseColor headerBg = new BaseColor(52, 73, 94);
            BaseColor rowAlt   = new BaseColor(236,240,241);
            boolean alternate  = false;

            // Cabeceras
            for (String h : headers) {
                PdfPCell c = new PdfPCell(new Phrase(h, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE)));
                c.setBackgroundColor(headerBg);
                c.setHorizontalAlignment(Element.ALIGN_CENTER);
                c.setPadding(6);
                tbl.addCell(c);
            }

            // Datos o fila vacía
            if (data.isEmpty()) {
                PdfPCell c = new PdfPCell(new Phrase("Sin registros",
                    FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 10, BaseColor.GRAY)));
                c.setColspan(headers.length);
                c.setHorizontalAlignment(Element.ALIGN_CENTER);
                c.setPadding(10);
                tbl.addCell(c);
            } else {
                for (String[] row : data) {
                    BaseColor bg = alternate ? rowAlt : BaseColor.WHITE;
                    for (String v : row) {
                        PdfPCell c = new PdfPCell(new Phrase(v, FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.BLACK)));
                        c.setBackgroundColor(bg);
                        c.setHorizontalAlignment(Element.ALIGN_CENTER);
                        c.setPadding(4);
                        tbl.addCell(c);
                    }
                    alternate = !alternate;
                }
            }

            doc.add(tbl);
            doc.close();
            return baos.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Error generando PDF vertical", e);
        }
    }

    // ======
    private byte[] generarExcel(String[] headers, List<String[]> data,
                            String titulo, String periodoTexto, String anioTexto,
                            String nivelTexto, String gradoTexto, String seccionTexto) {
    try (Workbook wb = new XSSFWorkbook();
         ByteArrayOutputStream baos = new ByteArrayOutputStream()) {

        Sheet sheet = wb.createSheet("Reporte");

        // === Estilos ===
        CellStyle titleSt = wb.createCellStyle();
        Font titleF = wb.createFont(); titleF.setBold(true); titleF.setFontHeightInPoints((short)14);
        titleSt.setFont(titleF);
        titleSt.setAlignment(HorizontalAlignment.CENTER);

        CellStyle rightAlignSt = wb.createCellStyle();
        rightAlignSt.cloneStyleFrom(titleSt);
        rightAlignSt.setAlignment(HorizontalAlignment.RIGHT);

        CellStyle hdrSt = wb.createCellStyle();
        Font hdrF = wb.createFont(); hdrF.setBold(true);
        hdrSt.setFont(hdrF);
        hdrSt.setAlignment(HorizontalAlignment.CENTER);
        hdrSt.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        hdrSt.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        hdrSt.setBorderBottom(BorderStyle.THIN);

        int lastCol = headers.length - 1;

        // === Fila 0: Título del colegio
        Row r0 = sheet.createRow(0);
        Cell c0 = r0.createCell(0);
        c0.setCellValue(NOMBRE_COLEGIO);
        c0.setCellStyle(titleSt);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, lastCol));

        // === Fila 1: Título del reporte (izquierda) + Fecha (derecha)
        Row r1 = sheet.createRow(1);
        Cell c1a = r1.createCell(0);
        c1a.setCellValue(String.format("%s – %s / Año %s", titulo, periodoTexto, anioTexto));
        c1a.setCellStyle(titleSt);
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, lastCol - 1));

        Cell c1b = r1.createCell(lastCol);
        c1b.setCellValue("Fecha: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
        c1b.setCellStyle(rightAlignSt);

        // === Fila 2: Nivel, Grado, Sección
        Row r2 = sheet.createRow(2);
        Cell c2 = r2.createCell(0);
        c2.setCellValue(String.format("Nivel: %s   Grado: %s   Sección: %s", nivelTexto, gradoTexto, seccionTexto));
        c2.setCellStyle(titleSt);
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, lastCol));

        // === Fila 4: Cabeceras
        Row r4 = sheet.createRow(4);
        for (int i = 0; i < headers.length; i++) {
            Cell hc = r4.createCell(i);
            hc.setCellValue(headers[i]);
            hc.setCellStyle(hdrSt);
        }

        // === Datos
        int rn = 5;
        if (data.isEmpty()) {
            Row row = sheet.createRow(rn++);
            Cell c = row.createCell(0);
            c.setCellValue("Sin registros");
            for (int i = 1; i < headers.length; i++) {
                row.createCell(i).setCellValue("");
            }
        } else {
            for (String[] dr : data) {
                Row row = sheet.createRow(rn++);
                for (int j = 0; j < dr.length; j++) {
                    row.createCell(j).setCellValue(dr[j]);
                }
            }
        }

        for (int i = 0; i < headers.length; i++) sheet.autoSizeColumn(i);
        wb.write(baos);
        return baos.toByteArray();

    } catch (Exception e) {
        throw new RuntimeException("Error generando Excel", e);
    }
}

    private byte[] generarExcelVertical(String[] headers,
                                    List<String[]> data,
                                    String titulo,
                                    String periodoTexto,
                                    String anioTexto,
                                    String nivelTexto,
                                    String gradoTexto,
                                    String seccionTexto,
                                    String nombreAlumno) {
        try (Workbook wb = new XSSFWorkbook();
             ByteArrayOutputStream baos = new ByteArrayOutputStream()) {

            Sheet sheet = wb.createSheet("Reporte");

            CellStyle titleSt = wb.createCellStyle();
            Font titleF = wb.createFont(); titleF.setBold(true); titleF.setFontHeightInPoints((short)14);
            titleSt.setFont(titleF);

            CellStyle hdrSt = wb.createCellStyle();
            Font hdrF = wb.createFont(); hdrF.setBold(true);
            hdrSt.setFont(hdrF);
            hdrSt.setFillForegroundColor(IndexedColors.GREY_50_PERCENT.getIndex());
            hdrSt.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            // Colegio + título
            Row r0 = sheet.createRow(0);
            Cell c0 = r0.createCell(0);
            c0.setCellValue(String.format("%s – %s / Año %s", NOMBRE_COLEGIO, periodoTexto, anioTexto));
            c0.setCellStyle(titleSt);
            sheet.addMergedRegion(new CellRangeAddress(0,0,0,headers.length-1));

            // Nombre alumno
            Row r1 = sheet.createRow(1);
            Cell c1 = r1.createCell(0);
            c1.setCellValue("Alumno: " + nombreAlumno);
            c1.setCellStyle(titleSt);
            sheet.addMergedRegion(new CellRangeAddress(1,1,0,headers.length-1));

            // Nivel/Grado/Sección
            Row r2 = sheet.createRow(2);
            Cell c2 = r2.createCell(0);
            c2.setCellValue(String.format("Nivel: %s   Grado: %s   Sección: %s", nivelTexto, gradoTexto, seccionTexto));
            sheet.addMergedRegion(new CellRangeAddress(2,2,0,headers.length-1));

            // Encabezados
            Row r3 = sheet.createRow(3);
            for (int i=0; i<headers.length; i++) {
                Cell hc = r3.createCell(i);
                hc.setCellValue(headers[i]);
                hc.setCellStyle(hdrSt);
            }

            // Datos o fila vacía
            int rn=4;
            if (data.isEmpty()) {
                Row row = sheet.createRow(rn++);
                Cell c = row.createCell(0);
                c.setCellValue("Sin registros");
                for (int i=1; i<headers.length; i++) {
                    row.createCell(i).setCellValue("");
                }
            } else {
                for (String[] dr : data) {
                    Row row = sheet.createRow(rn++);
                    for (int j=0; j<dr.length; j++) {
                        row.createCell(j).setCellValue(dr[j]);
                    }
                }
            }

            for (int i=0; i<headers.length; i++) sheet.autoSizeColumn(i);
            wb.write(baos);
            return baos.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Error generando Excel vertical", e);
        }
    }

    // ========== Construcción de datos para consolidado ==========
    private ConsolidadoData construirTablaNotas(int anioId, int periodoId, int seccionId,
                                                int nivelId, int gradoId,
                                                String tipoNota, String alumnoFiltro)
            throws SQLException {

        // 1) obtengo abreviaturas de asignaturas (método horizontal)
        String sqlAsig ="SELECT DISTINCT c.nombre AS nombre, m.orden " +
                        "FROM malla_curricular m " +
                        " JOIN apertura_seccion aps ON m.id_apertura_seccion = aps.id_apertura_seccion " +
                        " JOIN curso c ON m.id_curso = c.id_curso " +
                        "WHERE aps.id_anio_lectivo = ? AND aps.id_seccion = ? " +
                        "  AND aps.id_grado = ? AND aps.activo = 1 AND m.activo = 1 " +
                        "ORDER BY m.orden";


        List<String> todas = new ArrayList<>();
        List<String> calc  = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlAsig)) {
            ps.setInt(1, anioId);
            ps.setInt(2, seccionId);
            ps.setInt(3, gradoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String nombre = rs.getString("nombre");
                    String abrev   = abreviarCurso(nombre);
                    todas.add(abrev);
                    if (rs.getInt("orden") <= 100) {
                        calc.add(abrev);
                    }
                }
            }
        }

        // 2) obtengo alumnos
        List<Alumno> alumnos = alumnoDAO.listarMatriculadosPorFiltros(
            anioId, nivelId, gradoId, seccionId
        );

        // 3) inicializo la tabla
        Map<Integer,Map<String,String>> tabla = new LinkedHashMap<>();
        for (Alumno a : alumnos) {
            Map<String,String> fila = new HashMap<>();
            for (String c : todas) fila.put(c, "");
            tabla.put(a.getIdAlumno(), fila);
        }

        // 4) cargo notas
        String sqlNotas =
            "SELECT al.id_alumno, c.nombre AS nombre, cal.nota " +
            "FROM calificacion cal " +
            " JOIN alumno al ON cal.id_alumno=al.id_alumno " +
            " JOIN malla_criterio mc ON cal.id_malla_criterio=mc.id_malla_criterio " +
            " JOIN malla_curricular m ON mc.id_malla_curricular=m.id_malla_curricular " +
            " JOIN curso c ON m.id_curso=c.id_curso " +
            " JOIN apertura_seccion aps ON m.id_apertura_seccion=aps.id_apertura_seccion " +
            "WHERE aps.id_anio_lectivo=? AND mc.id_periodo=? AND aps.id_seccion=?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlNotas)) {
            ps.setInt(1, anioId);
            ps.setInt(2, periodoId);
            ps.setInt(3, seccionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int idAl = rs.getInt("id_alumno");
                    if (!tabla.containsKey(idAl)) continue;
                    if (alumnoFiltro!=null && !alumnoFiltro.isEmpty()
                        && !alumnoFiltro.equals(String.valueOf(idAl))) continue;
                    String nom   = rs.getString("nombre");
                    String clave = abreviarCurso(nom);
                    double raw   = rs.getDouble("nota");
                    String val   = tipoNota.equalsIgnoreCase("numerico")
                                 ? String.format(Locale.US,"%.2f", raw)
                                 : convertirANotaLetra(raw);
                    tabla.get(idAl).put(clave, val);
                }
            }
        }

        // 5) cálculo de promedios y orden para OM
        Map<Integer,Double> proms = new HashMap<>();
        if ("numerico".equalsIgnoreCase(tipoNota)) {
            for (Alumno a : alumnos) {
                double sum=0; int cnt=0;
                for (String c : calc) {
                    String v = tabla.get(a.getIdAlumno()).get(c);
                    if (v!=null && !v.isEmpty()) {
                        sum += Double.parseDouble(v);
                        cnt++;
                    }
                }
                proms.put(a.getIdAlumno(), cnt==0?0:sum/cnt);
            }
        }
        List<Double> valores = new ArrayList<>(new HashSet<>(proms.values()));
        valores.sort(Comparator.reverseOrder());

        // 6) construyo encabezados
        List<String> hdr = new ArrayList<>();
        hdr.add("Nº"); hdr.add("Apellidos y Nombres");
        hdr.addAll(todas);
        hdr.addAll(Arrays.asList("PTJ","PRO","OM","DES"));

        // 7) filas
        List<String[]> rows = new ArrayList<>();
        int idx=1;
        for (Alumno a : alumnos) {
            if (alumnoFiltro!=null && !alumnoFiltro.isEmpty()
                && !alumnoFiltro.equals(String.valueOf(a.getIdAlumno()))) continue;
            List<String> r = new ArrayList<>();
            r.add(String.valueOf(idx++));
            r.add(a.getApellidos()+" "+a.getNombres());
            for (String c : todas) r.add(tabla.get(a.getIdAlumno()).get(c));

            String ptj="", pro="", om="", des="";
            if ("numerico".equalsIgnoreCase(tipoNota)) {
                double sum=0; int cnt=0;
                for (String c : calc) {
                    String v = tabla.get(a.getIdAlumno()).get(c);
                    if (v!=null && !v.isEmpty()) {
                        sum += Double.parseDouble(v);
                        cnt++;
                    }
                }
                ptj = String.format(Locale.US,"%.2f",sum);
                pro = cnt==0?"":String.format(Locale.US,"%.2f",sum/cnt);
                if (nivelId==SECUNDARIA_NIVEL_ID) {
                    double p = proms.get(a.getIdAlumno());
                    om = String.valueOf(valores.indexOf(p)+1);
                }
                int repro=0;
                for (String c : calc) {
                    String v = tabla.get(a.getIdAlumno()).get(c);
                    if (v!=null && !v.isEmpty() && Double.parseDouble(v)<11) repro++;
                }
                des = String.valueOf(repro);
            }
            r.add(ptj); r.add(pro); r.add(om); r.add(des);
            rows.add(r.toArray(new String[0]));
        }

        return new ConsolidadoData(hdr.toArray(new String[0]), rows);
    }

    private String convertirANotaLetra(Double n) {
        if (n == null || n == 0) return "";
        if (n>=18) return "AD";
        if (n>=15) return "A";
        if (n>=13) return "B";
        if (n>=11) return "C";
        return "C";
    }

    // ========== Helpers internos ==========
    private String obtenerNombreNivel(int idNivel) {
        return academicoDAO.listarNiveles().stream()
            .filter(n -> n.getIdNivel()==idNivel)
            .map(Nivel::getNombre).findFirst().orElse("");
    }
    private String obtenerNombreGrado(int idGrado) {
        return academicoDAO.listarGrados().stream()
            .filter(g -> g.getIdGrado()==idGrado)
            .map(Grado::getNombre).findFirst().orElse("");
    }
    private String obtenerNombreSeccion(int idSeccion) {
        return academicoDAO.listarSecciones().stream()
            .filter(s -> s.getIdSeccion()==idSeccion)
            .map(Seccion::getNombre).findFirst().orElse("");
    }

    private String nombrePeriodo(int anioId, int periodoId) {
        Optional<Periodo> opt = periodoDAO
            .listarPorAnioLectivo(anioId).stream()
            .filter(p -> p.getIdPeriodo() == periodoId)
            .findFirst();

        if (!opt.isPresent()) {
            return "Periodo " + periodoId;
        }

        Periodo p = opt.get();
        String nombre = "Bimestre " + p.getBimestre();

        if ("mensual".equalsIgnoreCase(p.getTipo())) {
            nombre += " – Mes " + p.getMes();
        }

        return nombre;
    }


    private int lookupId(String tipo, String nombre) throws SQLException {
        String table = tipo.equals("nivel") ? "nivel"
                     : tipo.equals("grado") ? "grado"
                                             : "seccion";
        String sql   = String.format("SELECT id_%s FROM %s WHERE nombre=?", table, table);
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("No se encontró " + tipo + " con nombre " + nombre);
    }
    public String abreviarCurso(String nombreCurso) {
        String[] palabras = nombreCurso.split("\\s+");

        if (palabras.length == 1) {
            if (palabras[0].length() >= 2) {
                return palabras[0].substring(0, 2).toUpperCase();
            } else {
                return palabras[0].toUpperCase();
            }
        } else {
            return Arrays.stream(palabras)
                         .map(w -> w.substring(0, 1).toUpperCase())
                         .collect(Collectors.joining());
        }
    }

    // ========== DTO interno ==========
    public static class ConsolidadoData {
        public final String[] headers;
        public final List<String[]> filas;
        public ConsolidadoData(String[] h, List<String[]> f) {
            this.headers = h;
            this.filas   = f;
        }
    }
}