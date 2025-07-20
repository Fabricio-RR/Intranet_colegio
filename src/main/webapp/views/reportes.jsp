<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <c:set var="paginaActiva" value="Reportes" scope="request"/>
  <jsp:include page="/includes/meta.jsp"/>
  <title>Reportes Académicos - Intranet Escolar</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/assets/css/formularios.css" rel="stylesheet"/>
  <style>
    .report-icon { font-size:2rem;color:#0A0A3D;margin-right:10px; }
    .accordion-button:not(.collapsed){color:#0A0A3D;background:#f4f6fa;}
    .accordion-item{border-radius:8px;overflow:hidden;margin-bottom:1rem;}
    .accordion-body{background:#fbfcfe;}
    .custom-tabs .nav-link{border:none;background:none;color:#2563eb;font-weight:500;
      border-radius:8px 8px 0 0;padding:.7rem 1.5rem;transition:color .2s;}
    .custom-tabs .nav-link.active{background:#fff;color:#222;border:2px solid #eee;
      border-bottom:2px solid #fff;border-radius:12px 12px 0 0;font-weight:700;z-index:2;}
    .custom-tabs .nav-link:not(.active):hover{text-decoration:underline;color:#0A0A3D;}
    .custom-tabs{border-bottom:1.5px solid #eee;}
  </style>
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp"/>
<c:set var="tituloPaginaDesktop" value="Reportes Académicos" scope="request"/>
<c:set var="tituloPaginaMobile"  value="Reportes" scope="request"/>
<c:set var="iconoPagina"         value="fas fa-clipboard-list" scope="request"/>
<jsp:include page="/includes/header.jsp"/>

<main class="main-content container py-4">
  <!-- FILTROS GLOBALES -->
  <form id="filtrosReportes" method="get" action="">
    <div class="row g-3 mb-4 align-items-end">
      <div class="col-auto">
        <label class="form-label">Año lectivo</label>
        <select name="anio_lectivo" class="form-select" onchange="this.form.submit()">
          <c:forEach items="${aniosLectivos}" var="anio">
            <option value="${anio.idAnioLectivo}" <c:if test="${anio.idAnioLectivo == anioSeleccionado}">selected</c:if>>
              ${anio.nombre}
            </option>
          </c:forEach>
        </select>
      </div>
      <div class="col-auto">
        <label class="form-label">Periodo</label>
        <select name="periodo" class="form-select" onchange="this.form.submit()">
          <option value="">--</option>
          <c:forEach items="${periodos}" var="p">
            <option value="${p.idPeriodo}" <c:if test="${p.idPeriodo == periodoSeleccionado}">selected</c:if>>
              ${p.nombre}
            </option>
          </c:forEach>
        </select>
      </div>
      <div class="col-auto">
        <label class="form-label">Nivel</label>
        <select name="nivel" class="form-select" onchange="this.form.submit()">
          <option value="">--</option>
          <c:forEach items="${niveles}" var="n">
            <option value="${n.idNivel}" <c:if test="${n.idNivel == nivelSeleccionado}">selected</c:if>>
              ${n.nombre}
            </option>
          </c:forEach>
        </select>
      </div>
      <div class="col-auto">
        <label class="form-label">Grado</label>
        <select name="grado" class="form-select" onchange="this.form.submit()">
          <option value="">--</option>
          <c:forEach items="${grados}" var="g">
            <option value="${g.idGrado}" <c:if test="${g.idGrado == gradoSeleccionado}">selected</c:if>>
              ${g.nombre}
            </option>
          </c:forEach>
        </select>
      </div>
      <div class="col-auto">
        <label class="form-label">Sección</label>
        <select name="seccion" class="form-select" onchange="this.form.submit()">
          <option value="">--</option>
          <c:forEach items="${secciones}" var="s">
            <option value="${s.idSeccion}" <c:if test="${s.idSeccion == seccionSeleccionada}">selected</c:if>>
              ${s.nombre}
            </option>
          </c:forEach>
        </select>
      </div>
    </div>
  </form>

  <!-- TABS -->
  <ul class="nav nav-tabs custom-tabs mb-4" role="tablist">
    <li class="nav-item">
      <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#panel-generacion" type="button">
        <i class="fas fa-download me-1"></i> Generación & Descarga
      </button>
    </li>
    <!--
    <li class="nav-item">
      <button class="nav-link" data-bs-toggle="tab" data-bs-target="#panel-historial" type="button">
        <i class="fas fa-history me-1"></i> Historial Publicado
      </button>
    </li>-->
  </ul>

  <div class="tab-content">

    <!-- GENERACIÓN -->
    <div class="tab-pane fade show active" id="panel-generacion">
      <div class="accordion" id="accordionReportes">

        <!-- 1. Asistencia (Mensual) - por Alumno -->
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#colAsistencia">
              <i class="fas fa-calendar-check report-icon"></i> Asistencia Mensual 
            </button>
          </h2>
          <div id="colAsistencia" class="accordion-collapse collapse show" data-bs-parent="#accordionReportes">
            <div class="accordion-body">
              <form id="formAsistencia" method="get" action="${pageContext.request.contextPath}/reportes/asistencia" class="row g-3">
                <input type="hidden" name="anio_lectivo" value="${anioSeleccionado}"/>
                <input type="hidden" name="periodo"      value="${periodoSeleccionado}"/>
                <input type="hidden" name="mes"          value="${mesSeleccionado}"/>
                <input type="hidden" name="nivel"        value="${nivelSeleccionado}"/>
                <input type="hidden" name="grado"        value="${gradoSeleccionado}"/>
                <input type="hidden" name="seccion"      value="${seccionSeleccionada}"/>
                
                <div class="col-md-2">
                  <label class="form-label">Formato</label>
                  <select name="formato" class="form-select" required>
                    <option value="pdf">PDF</option>
                    <option value="excel">Excel</option>
                    <!--<option value="word">Word</option>-->
                  </select>
                </div>
                <div class="col-12 d-flex gap-2">
                  <button type="submit" class="btn btn-admin-primary">
                    <i class="fas fa-download"></i> Descargar
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- 2. Consolidado de Notas mensual (Sección) -->
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#colConsolidadoMes">
              <i class="fas fa-journal-whills report-icon"></i> Consolidado de Notas Mensual (Sección)
            </button>
          </h2>
          <div id="colConsolidadoMes" class="accordion-collapse collapse" data-bs-parent="#accordionReportes">
            <div class="accordion-body">
              <form id="formConsolidadoMes" method="get" action="${pageContext.request.contextPath}/reportes/consolidado_mensual" class="row g-3">
                <input type="hidden" name="anio_lectivo" value="${anioSeleccionado}"/>
                <input type="hidden" name="periodo"      value="${periodoSeleccionado}"/>
                <input type="hidden" name="mes"          value="${mesSeleccionado}"/>
                <input type="hidden" name="nivel"        value="${nivelSeleccionado}"/>
                <input type="hidden" name="grado"        value="${gradoSeleccionado}"/>
                <input type="hidden" name="seccion"      value="${seccionSeleccionada}"/>
                <div class="col-md-2">
                  <label class="form-label">Formato</label>
                  <select name="formato" class="form-select" required>
                    <option value="pdf">PDF</option>
                    <option value="excel">Excel</option>
                    <!--<option value="word">Word</option>-->
                  </select>
                </div>
                <div class="col-md-2">
                  <label class="form-label">Tipo Nota</label>
                  <select name="tipo" class="form-select" required>
                    <option value="letra">Letra</option>
                    <option value="numerico">Numérico</option>
                  </select>
                </div>
                <div class="col-12 d-flex gap-2">
                  <button type="submit" class="btn btn-admin-primary">
                    <i class="fas fa-download"></i> Descargar
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- 3. Consolidado de Notas Bimestral (Sección) -->
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#colConsolidadoBim">
              <i class="fas fa-journal-whills report-icon"></i> Consolidado de Notas Bimestral (Sección)
            </button>
          </h2>
          <div id="colConsolidadoBim" class="accordion-collapse collapse" data-bs-parent="#accordionReportes">
            <div class="accordion-body">
              <form id="formConsolidadoBim" method="get" action="${pageContext.request.contextPath}/reportes/consolidado_bimestral" class="row g-3">
                <input type="hidden" name="anio_lectivo" value="${anioSeleccionado}"/>
                <input type="hidden" name="periodo"      value="${periodoSeleccionado}"/>
                <input type="hidden" name="nivel"        value="${nivelSeleccionado}"/>
                <input type="hidden" name="grado"        value="${gradoSeleccionado}"/>
                <input type="hidden" name="seccion"      value="${seccionSeleccionada}"/>
                <div class="col-md-2">
                  <label class="form-label">Formato</label>
                  <select name="formato" class="form-select" required>
                    <option value="pdf">PDF</option>
                    <option value="excel">Excel</option>
                    <!--<option value="word">Word</option>-->
                  </select>
                </div>
                <div class="col-md-2">
                  <label class="form-label">Tipo Nota</label>
                  <select name="tipo" class="form-select" required>
                    <option value="letra">Letra</option>
                    <option value="numerico">Numérico</option>
                  </select>
                </div>
                <div class="col-12 d-flex gap-2">
                  <button type="submit" class="btn btn-admin-primary">
                    <i class="fas fa-download"></i> Descargar
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- 4. Libreta de Notas Bimestral -->
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#colLibretaBim">
              <i class="fas fa-book report-icon"></i> Libreta de Notas Bimestral
            </button>
          </h2>
          <div id="colLibretaBim"
               class="accordion-collapse collapse"
               data-bs-parent="#accordionReportes">
            <div class="accordion-body">

              <!-- 4.1) Formulario unitario -->
              <form id="formLibretaBim"
                    method="get"
                    action="${pageContext.request.contextPath}/reportes/libreta_bimestral"
                    class="row g-3 mb-3">
                <input type="hidden" name="anio_lectivo" value="${anioSeleccionado}"/>
                <input type="hidden" name="periodo"      value="${periodoSeleccionado}"/>
                <input type="hidden" name="nivel"        value="${nivelSeleccionado}"/>
                <input type="hidden" name="grado"        value="${gradoSeleccionado}"/>
                <input type="hidden" name="seccion"      value="${seccionSeleccionada}"/>

                <div class="col-md-4">
                  <label class="form-label">Alumno</label>
                  <select name="alumno" class="form-select" required>
                    <option value="">Seleccione</option>
                    <c:forEach items="${alumnos}" var="al">
                      <option value="${al.idAlumno}"
                        <c:if test="${al.idAlumno == alumnoSeleccionado}">selected</c:if>>
                        ${al.apellidos} ${al.nombres}
                      </option>
                    </c:forEach>
                  </select>
                </div>

                <div class="col-md-2">
                  <label class="form-label">Formato</label>
                  <select name="formato" class="form-select" required>
                    <option value="pdf">PDF</option>
                    <option value="excel">Excel</option>
                    <!--<option value="word">Word</option>-->
                  </select>
                </div>

                <div class="col-md-2">
                  <label class="form-label">Tipo Nota</label>
                  <select name="tipo" class="form-select" required>
                    <option value="letra">Letra</option>
                    <option value="numerico">Numérico</option>
                  </select>
                </div>

                <div class="col-12 d-flex gap-2">
                  <button type="submit" class="btn btn-admin-primary">
                    <i class="fas fa-download"></i> Descargar
                  </button>
                  <button type="button" class="btn btn-outline-primary"
                          onclick="
                            const p = new URLSearchParams(new FormData(
                              document.getElementById('formLibretaBim')
                            ));
                            window.open(
                              '${pageContext.request.contextPath}/reportes/bloque?tipo=libreta_bimestral&'+p,
                              '_blank'
                            );
                          ">
                    <i class="fas fa-archive"></i> Descargar Bloque ZIP
                  </button>
                </div>
              </form>

            </div>
          </div>
        </div>

        <!-- 5. Libreta de Notas General -->
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#colLibretaGen">
              <i class="fas fa-book-open report-icon"></i> Libreta de Notas General
            </button>
          </h2>
          <div id="colLibretaGen"
               class="accordion-collapse collapse"
               data-bs-parent="#accordionReportes">
            <div class="accordion-body">

              <!-- 5.1) Formulario unitario -->
              <form id="formLibretaGen"
                    method="get"
                    action="${pageContext.request.contextPath}/reportes/libreta"
                    class="row g-3 mb-3">
                <input type="hidden" name="anio_lectivo" value="${anioSeleccionado}"/>
                <input type="hidden" name="nivel"        value="${nivelSeleccionado}"/>
                <input type="hidden" name="grado"        value="${gradoSeleccionado}"/>
                <input type="hidden" name="seccion"      value="${seccionSeleccionada}"/>

                <div class="col-md-4">
                  <label class="form-label">Alumno</label>
                  <select name="alumno" class="form-select" required>
                    <option value="">Seleccione</option>
                    <c:forEach items="${alumnos}" var="al">
                      <option value="${al.idAlumno}"
                        <c:if test="${al.idAlumno == alumnoSeleccionado}">selected</c:if>>
                        ${al.apellidos} ${al.nombres}
                      </option>
                    </c:forEach>
                  </select>
                </div>

                <div class="col-md-2">
                  <label class="form-label">Formato</label>
                  <select name="formato" class="form-select" required>
                    <option value="pdf">PDF</option>
                    <option value="excel">Excel</option>
                    <!--<option value="word">Word</option>-->
                  </select>
                </div>

                <div class="col-md-2">
                  <label class="form-label">Tipo Nota</label>
                  <select name="tipo" class="form-select" required>
                    <option value="letra">Letra</option>
                    <option value="numerico">Numérico</option>
                  </select>
                </div>

                <div class="col-12 d-flex gap-2">
                  <button type="submit" class="btn btn-admin-primary">
                    <i class="fas fa-download"></i> Descargar
                  </button>
                  <button type="button" class="btn btn-outline-primary"
                          onclick="
                            const p = new URLSearchParams(new FormData(
                              document.getElementById('formLibretaGen')
                            ));
                            window.open(
                              '${pageContext.request.contextPath}/reportes/bloque?tipo=libreta_general&'+p,
                              '_blank'
                            );
                          ">
                    <i class="fas fa-archive"></i> Descargar Bloque ZIP
                  </button>
                </div>
              </form>

            </div>
          </div>
        </div>

        <!-- 6. Progreso del Alumno Mensual -->
        <!--
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#colProgreso">
              <i class="fas fa-chart-line report-icon"></i> Progreso del Alumno Mensual
            </button>
          </h2>
          <div id="colProgreso"
               class="accordion-collapse collapse"
               data-bs-parent="#accordionReportes">
            <div class="accordion-body">

              <form id="formProgreso"
                    method="get"
                    action="${pageContext.request.contextPath}/reportes/progreso"
                    class="row g-3 mb-3">
                <input type="hidden" name="anio_lectivo" value="${anioSeleccionado}"/>
                <input type="hidden" name="nivel"        value="${nivelSeleccionado}"/>
                <input type="hidden" name="grado"        value="${gradoSeleccionado}"/>
                <input type="hidden" name="seccion"      value="${seccionSeleccionada}"/>

                <div class="col-md-4">
                  <label class="form-label">Alumno</label>
                  <select name="alumno" class="form-select" required>
                    <option value="">Seleccione</option>
                    <c:forEach items="${alumnos}" var="al">
                      <option value="${al.idAlumno}"
                        <c:if test="${al.idAlumno == alumnoSeleccionado}">selected</c:if>>
                        ${al.apellidos} ${al.nombres}
                      </option>
                    </c:forEach>
                  </select>
                </div>

                <div class="col-md-2">
                  <label class="form-label">Formato</label>
                  <select name="formato" class="form-select" required>
                    <option value="pdf">PDF</option>
                    <option value="excel">Excel</option>
                  </select>
                </div>

                <div class="col-md-2">
                  <label class="form-label">Tipo Nota</label>
                  <select name="tipo" class="form-select" required>
                    <option value="letra">Letra</option>
                    <option value="numerico">Numérico</option>
                  </select>
                </div>

                <div class="col-12 d-flex gap-2">
                  <button type="submit" class="btn btn-admin-primary">
                    <i class="fas fa-download"></i> Descargar
                  </button>
                  <button type="button" class="btn btn-outline-primary"
                          onclick="
                            const p = new URLSearchParams(new FormData(
                              document.getElementById('formProgreso')
                            ));
                            window.open(
                              '${pageContext.request.contextPath}/reportes/bloque?tipo=progreso&'+p,
                              '_blank'
                            );
                          ">
                    <i class="fas fa-archive"></i> Bloque ZIP
                  </button>
                </div>
              </form>

            </div>
          </div>
        </div>
        -->                      
        <!-- 7. Rendimiento Académico (mensual/bimestral, por alumno) 
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#colRendimiento">
              <i class="fas fa-chart-bar report-icon"></i> Rendimiento Académico
            </button>
          </h2>
          <div id="colRendimiento"
               class="accordion-collapse collapse"
               data-bs-parent="#accordionReportes">
            <div class="accordion-body">

              /*7.1) Formulario unitario */
              <form id="formRendimiento"
                    method="get"
                    action="${pageContext.request.contextPath}/reportes/rendimiento"
                    class="row g-3 mb-3">
                <input type="hidden" name="anio_lectivo" value="${anioSeleccionado}"/>
                <input type="hidden" name="periodo"      value="${periodoSeleccionado}"/>
                <input type="hidden" name="mes"          value="${mesSeleccionado}"/>
                <input type="hidden" name="nivel"        value="${nivelSeleccionado}"/>
                <input type="hidden" name="grado"        value="${gradoSeleccionado}"/>
                <input type="hidden" name="seccion"      value="${seccionSeleccionada}"/>

                <div class="col-md-6">
                  <label class="form-label">Alumno</label>
                  <select name="alumno" class="form-select" required>
                    <option value="">Seleccione</option>
                    <c:forEach items="${alumnos}" var="al">
                      <option value="${al.idAlumno}"
                        <c:if test="${al.idAlumno == alumnoSeleccionado}">selected</c:if>>
                        ${al.apellidos} ${al.nombres}
                      </option>
                    </c:forEach>
                  </select>
                </div>

                <div class="col-md-2">
                  <label class="form-label">Formato</label>
                  <select name="formato" class="form-select" required>
                    <option value="pdf">PDF</option>
                    <option value="excel">Excel</option>
                  </select>
                </div>

                <div class="col-md-2">
                  <label class="form-label">Tipo Nota</label>
                  <select name="tipo" class="form-select" required>
                    <option value="letra">Letra</option>
                    <option value="numerico">Numérico</option>
                  </select>
                </div>

                <div class="col-md-2">
                  <label class="form-label">Frecuencia</label>
                  <select name="frecuencia" class="form-select" required>
                    <option value="mensual">Mensual</option>
                    <option value="bimestral">Bimestral</option>
                  </select>
                </div>

                <div class="col-12 d-flex gap-2">
                  <button type="submit" class="btn btn-admin-primary">
                    <i class="fas fa-download"></i> Descargar
                  </button>
                </div>
              </form>

            </div>
          </div>
        </div>
      </div>
    </div>
    -->
    <!-- HISTORIAL DE REPORTES PUBLICADOS -->
    <div class="tab-pane fade" id="panel-historial">
      <div class="card mt-4">
        <div class="card-header bg-primary text-white">
          <i class="fas fa-history"></i> Historial de Reportes Publicados
        </div>
        <div class="table-responsive p-3">
          <table class="table table-hover mb-0">
            <thead>
              <tr>
                <th>Tipo</th><th>Periodo</th><th>Nivel</th>
                <th>Grado</th><th>Sección</th><th>Fecha</th>
                <th>Publicado por</th><th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${reportesPublicados}" var="rep">
                <tr>
                  <td>${rep.tipoReporte}</td>
                  <td>${rep.periodo}</td>
                  <td>${rep.nivel}</td>
                  <td>${rep.grado}</td>
                  <td>${rep.seccion}</td>
                  <td><fmt:formatDate value="${rep.fechaPublicacion}" pattern="dd/MM/yyyy HH:mm"/></td>
                  <td>${rep.publicadoPor}</td>
                  <td>
                    <a href="${pageContext.request.contextPath}/uploads/reportes/${rep.anio}/${rep.archivo}"
                       class="btn btn-sm btn-admin-primary" target="_blank">
                      <i class="fas fa-eye"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/uploads/reportes/${rep.anio}/${rep.archivo}"
                       download class="btn btn-sm btn-admin-primary">
                      <i class="fas fa-download"></i>
                    </a>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty reportesPublicados}">
                <tr>
                  <td colspan="8" class="text-center text-muted">
                    No hay reportes publicados para el año seleccionado.
                  </td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </div>

  </div> <!-- /tab-content -->

  <jsp:include page="/includes/footer.jsp"/>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
    