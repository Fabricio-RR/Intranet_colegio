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
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
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
    public byte[] generarAsistencia(int anioId, int periodoId, String mesCodigo,
                                    int nivelId, int gradoId, int seccionId,
                                    String alumnoFiltro, String formato) {
        String[] headers = {
            "Apellidos","Nombres",
            "Asistencias","Tardanzas","Tardanzas Justificadas",
            "Faltas","Faltas Justificadas"
        };
        List<String[]> data = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_reporte_asistencia(?,?,?,?,?,?)}")) {

            cs.setInt(1, anioId);
            cs.setInt(2, periodoId);
            cs.setString(3, mesCodigo);
            cs.setInt(4, nivelId);
            cs.setInt(5, gradoId);
            cs.setInt(6, seccionId);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    String cod = rs.getString("codigo_matricula");
                    if (alumnoFiltro == null || alumnoFiltro.isEmpty() || alumnoFiltro.equals(cod)) {
                        data.add(new String[]{
                            rs.getString("apellidos"),
                            rs.getString("nombres"),
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
        return dispatchFormat(
            formato,
            headers, data,
            "Asistencia",
            nombrePeriodo(anioId, periodoId, mesCodigo),
            anioDAO.obtenerNombrePorId(anioId),
            obtenerNombreNivel(nivelId),
            obtenerNombreGrado(gradoId),
            obtenerNombreSeccion(seccionId)
        );
    }

    // ========== 2. Rendimiento Académico (mensual) ==========
    public byte[] generarRendimiento(int anioId, int periodoId, String mesCodigo,
                                     int nivelId, int gradoId, int seccionId,
                                     String alumnoFiltro, String formato) {
        String[] headers = {"Apellidos","Nombres","Promedio","Condición"};
        List<String[]> data = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_reporte_rendimiento(?,?,?,?,?,?)}")) {

            cs.setInt(1, anioId);
            cs.setInt(2, periodoId);
            cs.setString(3, mesCodigo);
            cs.setInt(4, nivelId);
            cs.setInt(5, gradoId);
            cs.setInt(6, seccionId);
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
            nombrePeriodo(anioId, periodoId, mesCodigo),
            anioDAO.obtenerNombrePorId(anioId),
            obtenerNombreNivel(nivelId),
            obtenerNombreGrado(gradoId),
            obtenerNombreSeccion(seccionId)
        );
    }

    // ========== 3. Consolidado de Notas (mensual o bimestral, horizontal) ==========
    public byte[] generarConsolidado(int anioId, int periodoId, String mesCodigo,
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
                nombrePeriodo(anioId, periodoId, mesCodigo),
                anioDAO.obtenerNombrePorId(anioId),
                obtenerNombreNivel(nivelId),
                obtenerNombreGrado(gradoId),
                obtenerNombreSeccion(seccionId)
            );
        } catch (SQLException e) {
            throw new RuntimeException("Error generando consolidado", e);
        }
    }

    // ========== 4. Libreta de Notas Bimestral (horizontal) ==========
    public byte[] generarLibretaBimestral(int anioId, int bimestreId,
                                          int nivelId, int gradoId, int seccionId,
                                          String tipoNota, String alumnoFiltro, String formato) {
        return generarConsolidado(
            anioId, bimestreId, null,
            nivelId, gradoId, seccionId,
            tipoNota, alumnoFiltro, formato
        );
    }

    // ========== 5. Libreta de Notas General (vertical) ==========
    public byte[] generarLibretaGeneral(int anioId,
                                        int nivelId, int gradoId, int seccionId,
                                        String tipoNota, String alumnoFiltro, String formato) {
        String[] headers = {
            "No","Apellidos y Nombres","Curso",
            "I","II","III","IV","Promedio Anual"
        };
        List<String[]> data = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_reporte_libreta_general(?,?,?,?,?)}")) {

            cs.setInt(1, anioId);
            cs.setInt(2, nivelId);
            cs.setInt(3, gradoId);
            cs.setInt(4, seccionId);
            cs.setString(5, alumnoFiltro == null ? "" : alumnoFiltro);
            try (ResultSet rs = cs.executeQuery()) {
                int idx = 1;
                while (rs.next()) {
                    data.add(new String[]{
                        String.valueOf(idx++),
                        rs.getString("apellidos") + " " + rs.getString("nombres"),
                        rs.getString("curso"),
                        rs.getString("nota_I"),
                        rs.getString("nota_II"),
                        rs.getString("nota_III"),
                        rs.getString("nota_IV"),
                        rs.getString("nota_anual")
                    });
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error generando libreta general", e);
        }
        return dispatchFormat(
            formato,
            headers, data,
            "Libreta General",
            "General",
            anioDAO.obtenerNombrePorId(anioId),
            obtenerNombreNivel(nivelId),
            obtenerNombreGrado(gradoId),
            obtenerNombreSeccion(seccionId)
        );
    }

    // ========== 6. Progreso del Alumno Mensual (vertical) ==========
    public byte[] generarProgreso(int anioId, int nivelId, int gradoId, int seccionId,
                                  String alumnoFiltro, String formato) {
        String[] headers = {
            "Apellidos","Nombres","Curso","Nota Parcial","Nota Final"
        };
        List<String[]> data = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_reporte_progreso(?,?,?,?,?)}")) {

            cs.setInt(1, anioId);
            cs.setInt(2, nivelId);
            cs.setInt(3, gradoId);
            cs.setInt(4, seccionId);
            cs.setString(5, alumnoFiltro == null ? "" : alumnoFiltro);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    data.add(new String[]{
                        rs.getString("apellidos"),
                        rs.getString("nombres"),
                        rs.getString("curso"),
                        rs.getString("nota_parcial"),
                        rs.getString("nota_final")
                    });
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error generando progreso", e);
        }
        return dispatchFormat(
            formato,
            headers, data,
            "Progreso",
            "Progreso",
            anioDAO.obtenerNombrePorId(anioId),
            obtenerNombreNivel(nivelId),
            obtenerNombreGrado(gradoId),
            obtenerNombreSeccion(seccionId)
        );
    }

    // ========== 7. Certificado Anual (vertical) ==========
    public byte[] generarCertificadoAnual(int anioId, int nivelId, int gradoId, int seccionId,
                                          String alumnoFiltro, String formato) {
        return generarLibretaGeneral(
            anioId, nivelId, gradoId, seccionId,
            "numerico", alumnoFiltro, formato
        );
    }

    // ========== 8. Bloque ZIP de todos los alumnos ==========
    public byte[] generarBloqueZip(int anioId, String periodoStr,
                                   String nivelName, String gradoName, String seccionName,
                                   String tipoReporte, String tipoNota,
                                   String alumnoFiltro, String formato)
            throws IOException, SQLException {

        int idNivel   = lookupId("nivel",   nivelName);
        int idGrado   = lookupId("grado",   gradoName);
        int idSeccion = lookupId("seccion", seccionName);

        List<Alumno> alumnos = alumnoDAO.listarMatriculadosPorFiltros(
            anioId, idNivel, idGrado, idSeccion
        );
        List<byte[]> archivos = new ArrayList<>();
        List<String> nombres  = new ArrayList<>();
        String ext = formato.equalsIgnoreCase("excel") ? "xlsx"
                   : formato.equalsIgnoreCase("word")  ? "docx"
                                                       : "pdf";

        for (Alumno al : alumnos) {
            byte[] rpt;
            String fileName = al.getApellidos().replace(" ", "_")
                            + "_" + al.getNombres().replace(" ", "_")
                            + "." + ext;
            switch (tipoReporte) {
                case "asistencia":
                    rpt = generarAsistencia(
                        anioId, Integer.parseInt(periodoStr), "",
                        idNivel, idGrado, idSeccion, alumnoFiltro, formato
                    );
                    break;
                case "rendimiento":
                    rpt = generarRendimiento(
                        anioId, Integer.parseInt(periodoStr), "",
                        idNivel, idGrado, idSeccion, alumnoFiltro, formato
                    );
                    break;
                case "consolidado":
                    rpt = generarConsolidado(
                        anioId, Integer.parseInt(periodoStr), "",
                        idNivel, idGrado, idSeccion, tipoNota, alumnoFiltro, formato
                    );
                    break;
                case "libretaBimestral":
                    rpt = generarLibretaBimestral(
                        anioId, Integer.parseInt(periodoStr),
                        idNivel, idGrado, idSeccion, tipoNota, alumnoFiltro, formato
                    );
                    break;
                case "libretaGeneral":
                    rpt = generarLibretaGeneral(
                        anioId, idNivel, idGrado, idSeccion, tipoNota, alumnoFiltro, formato
                    );
                    break;
                case "progreso":
                    rpt = generarProgreso(
                        anioId, idNivel, idGrado, idSeccion, alumnoFiltro, formato
                    );
                    break;
                case "certificado":
                    rpt = generarCertificadoAnual(
                        anioId, idNivel, idGrado, idSeccion, alumnoFiltro, formato
                    );
                    break;
                default:
                    continue;
            }
            archivos.add(rpt);
            nombres.add(fileName);
        }

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
        } else if ("word".equalsIgnoreCase(formato)) {
            return generarWord(headers, data,
                titulo, periodoTexto, anioTexto,
                nivelTexto, gradoTexto, seccionTexto);
        } else {
            return generarPDF(headers, data,
                titulo, periodoTexto, anioTexto,
                nivelTexto, gradoTexto, seccionTexto);
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

            // Logo
            try {
                Image logo = Image.getInstance(getClass().getResource(RUTA_LOGO));
                logo.scaleToFit(80, 80);
                logo.setAbsolutePosition(36, doc.getPageSize().getHeight() - 100);
                doc.add(logo);
            } catch (Exception ignored) {}

            // Colegio y títulos
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
                String.format("Nivel: %s   Grado: %s   Sección: %s",
                              nivelTexto, gradoTexto, seccionTexto),
                FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.DARK_GRAY)
            );
            info.setAlignment(Element.ALIGN_CENTER);
            doc.add(info);
            doc.add(Chunk.NEWLINE);

            Paragraph fecha = new Paragraph(
                "Fecha: " + LocalDateTime.now()
                    .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 8)
            );
            fecha.setAlignment(Element.ALIGN_RIGHT);
            doc.add(fecha);
            doc.add(Chunk.NEWLINE);

            PdfPTable tbl = new PdfPTable(headers.length);
            tbl.setWidthPercentage(100);
            tbl.setHeaderRows(1);

            BaseColor headerBg = new BaseColor(52, 73, 94);
            BaseColor rowAlt   = new BaseColor(236,240,241);
            boolean alternate  = false;

            // Cabeceras
            for (String h : headers) {
                PdfPCell c = new PdfPCell(new Phrase(h,
                    FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE)));
                c.setBackgroundColor(headerBg);
                c.setHorizontalAlignment(Element.ALIGN_CENTER);
                c.setPadding(6);
                tbl.addCell(c);
            }
            // Filas
            for (String[] row : data) {
                BaseColor bg = alternate ? rowAlt : BaseColor.WHITE;
                for (String v : row) {
                    PdfPCell c = new PdfPCell(new Phrase(v,
                        FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.BLACK)));
                    c.setBackgroundColor(bg);
                    c.setHorizontalAlignment(Element.ALIGN_CENTER);
                    c.setPadding(4);
                    tbl.addCell(c);
                }
                alternate = !alternate;
            }

            doc.add(tbl);
            doc.close();
            return baos.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Error generando PDF", e);
        }
    }

    private byte[] generarExcel(String[] headers,
                                List<String[]> data,
                                String titulo,
                                String periodoTexto,
                                String anioTexto,
                                String nivelTexto,
                                String gradoTexto,
                                String seccionTexto) {
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

            // Fila 0: Colegio / periodo / nivel-grado-sección
            Row r0 = sheet.createRow(0);
            Cell c0 = r0.createCell(0);
            c0.setCellValue(
                String.format("%s – %s / Año %s   Nivel: %s   Grado: %s   Sección: %s",
                    NOMBRE_COLEGIO, periodoTexto, anioTexto,
                    nivelTexto, gradoTexto, seccionTexto)
            );
            c0.setCellStyle(titleSt);
            sheet.addMergedRegion(new CellRangeAddress(0,0,0,headers.length-1));

            // Fila 1: encabezados
            Row r1 = sheet.createRow(1);
            for (int i=0; i<headers.length; i++) {
                Cell hc = r1.createCell(i);
                hc.setCellValue(headers[i]);
                hc.setCellStyle(hdrSt);
            }

            // Datos
            int rn=2;
            for (String[] dr : data) {
                Row row = sheet.createRow(rn++);
                for (int j=0; j<dr.length; j++) {
                    row.createCell(j).setCellValue(dr[j]);
                }
            }

            for (int i=0; i<headers.length; i++) sheet.autoSizeColumn(i);
            wb.write(baos);
            return baos.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Error generando Excel", e);
        }
    }

    private byte[] generarWord(String[] headers,
                               List<String[]> data,
                               String titulo,
                               String periodoTexto,
                               String anioTexto,
                               String nivelTexto,
                               String gradoTexto,
                               String seccionTexto) {
        try (XWPFDocument doc = new XWPFDocument();
             ByteArrayOutputStream baos = new ByteArrayOutputStream()) {

            // Colegio
            XWPFParagraph p0 = doc.createParagraph();
            p0.setAlignment(ParagraphAlignment.CENTER);
            XWPFRun r0 = p0.createRun();
            r0.setBold(true); r0.setFontSize(16);
            r0.setText(NOMBRE_COLEGIO);

            // Título
            XWPFParagraph p1 = doc.createParagraph();
            p1.setAlignment(ParagraphAlignment.CENTER);
            XWPFRun r1 = p1.createRun();
            r1.setBold(true); r1.setFontSize(12);
            r1.setText(String.format("%s – %s / Año %s", titulo, periodoTexto, anioTexto));

            // Nivel / Grado / Sección
            XWPFParagraph p2 = doc.createParagraph();
            p2.setAlignment(ParagraphAlignment.CENTER);
            p2.createRun().setText(
                String.format("Nivel: %s   Grado: %s   Sección: %s",
                    nivelTexto, gradoTexto, seccionTexto)
            );

            doc.createParagraph().createRun().addBreak();

            // Tabla
            XWPFTable tbl = doc.createTable();
            XWPFTableRow hr = tbl.getRow(0);
            for (int i=0; i<headers.length; i++) {
                XWPFTableCell cell = (i==0 ? hr.getCell(0) : hr.addNewTableCell());
                cell.setText(headers[i]);
                CTShd hd = cell.getCTTc().getTcPr().addNewShd();
                hd.setFill("A9A9A9");
            }
            for (String[] dr : data) {
                XWPFTableRow rw = tbl.createRow();
                for (int i=0; i<dr.length; i++) {
                    rw.getCell(i).setText(dr[i] != null ? dr[i] : "");
                }
            }

            doc.write(baos);
            return baos.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Error generando Word", e);
        }
    }

    // ========== Construcción de datos para consolidado ==========
    private ConsolidadoData construirTablaNotas(int anioId, int periodoId, int seccionId,
                                                int nivelId, int gradoId,
                                                String tipoNota, String alumnoFiltro)
            throws SQLException {

        // 1) obtengo abreviaturas de asignaturas (método horizontal)
        String sqlAsig =
            "SELECT DISTINCT c.nombre AS nombre, m.orden " +
            "FROM malla_curricular m " +
            " JOIN apertura_seccion aps ON m.id_apertura_seccion=aps.id_apertura_seccion " +
            " JOIN malla_criterio mc ON m.id_malla_curricular=mc.id_malla_curricular " +
            " JOIN curso c ON m.id_curso=c.id_curso " +
            "WHERE aps.id_anio_lectivo=? AND mc.id_periodo=? AND aps.id_seccion=? " +
            "ORDER BY m.orden";

        List<String> todas = new ArrayList<>();
        List<String> calc  = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlAsig)) {
            ps.setInt(1, anioId);
            ps.setInt(2, periodoId);
            ps.setInt(3, seccionId);
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
        hdr.add("No"); hdr.add("Apellidos y Nombres");
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
        if (n==null) return "SN";
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

    private String nombrePeriodo(int anioId, int periodoId, String mesCodigo) {
        String base = periodoDAO.listarPorAnioLectivo(anioId).stream()
            .filter(p -> p.getIdPeriodo()==periodoId)
            .map(Periodo::getNombre)
            .findFirst().orElse("Periodo " + periodoId);
        return (mesCodigo!=null && !mesCodigo.isEmpty())
            ? base + " – Mes " + mesCodigo
            : base;
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
    /*
    private String abreviarCurso(String nombreCurso) {
        return Arrays.stream(nombreCurso.split("\\s+"))
                     .map(w -> w.substring(0,1).toUpperCase())
                     .collect(Collectors.joining());
    }
    */
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