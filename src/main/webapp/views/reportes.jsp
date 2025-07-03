<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Reportes" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Reportes Académicos - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/formularios.css" rel="stylesheet">
    <style>
        .report-icon { font-size: 2rem; color: #0A0A3D; margin-right: 10px; }
        .accordion-button:not(.collapsed) { color: #0A0A3D; background-color: #f4f6fa; }
        .accordion-item { border-radius: 8px; overflow: hidden; margin-bottom: 1rem; }
        .accordion-body { background: #fbfcfe; }
        .filtros-globales { background: #f4f6fa; border-radius: 0.5rem; padding: 1rem; margin-bottom: 2rem; }
        @media (max-width: 768px) {
            .report-icon { font-size: 1.5rem; }
            .filtros-globales { padding: 0.5rem; }
        }
        /* Tabs personalizados */
        .custom-tabs .nav-link {
            border: none;
            background: none;
            color: #2563eb;
            font-weight: 500;
            border-radius: 8px 8px 0 0;
            padding: 0.7rem 1.5rem;
            transition: color 0.2s;
        }
        .custom-tabs .nav-link.active {
            background: #fff;
            color: #222;
            border: 2px solid #eee;
            border-bottom: 2px solid #fff;
            border-radius: 12px 12px 0 0;
            font-weight: 700;
            z-index: 2;
        }
        .custom-tabs .nav-link:not(.active):hover {
            color: #0A0A3D;
            text-decoration: underline;
            background: none;
        }
        .custom-tabs {
            border-bottom: 1.5px solid #eee;
        }
    </style>
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Reportes Académicos" scope="request" />
<c:set var="tituloPaginaMobile" value="Reportes" scope="request" />
<c:set var="iconoPagina" value="fas fa-clipboard-list" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="row justify-content-center">
        <div class="col-lg-10">

            <!-- Filtro global: Año lectivo -->
            <form id="formAniosGlobal" method="get" action="">
                <div class="filtros-globales d-flex align-items-center gap-2 flex-wrap mb-4">
                    <label class="fw-semibold me-2 mb-0"><i class="fas fa-calendar-alt"></i> Año lectivo:</label>
                    <select name="anio_lectivo" id="anioLectivoSelect" class="form-select w-auto" onchange="cambiarAnioLectivo(this)">
                        <c:forEach items="${aniosLectivos}" var="anio">
                            <option value="${anio.idAnioLectivo}" <c:if test="${anio.activo}">selected</c:if>>
                                ${anio.nombre}
                            </option>
                        </c:forEach>
                    </select>
                    <span class="text-muted ms-3">(Filtra todos los reportes según el año seleccionado)</span>
                </div>
            </form>

            <!-- Tabs de navegación -->
            <ul class="nav nav-tabs custom-tabs mb-4" id="tabReportes" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="tab-generacion" data-bs-toggle="tab" data-bs-target="#panel-generacion" type="button" role="tab" aria-controls="panel-generacion" aria-selected="true">
                        <i class="fas fa-download me-1"></i> Descarga y generación de reportes
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="tab-historial" data-bs-toggle="tab" data-bs-target="#panel-historial" type="button" role="tab" aria-controls="panel-historial" aria-selected="false">
                        <i class="fas fa-history me-1"></i> Historial de reportes publicados
                    </button>
                </li>
            </ul>
            <div class="tab-content" id="tabReportesContent">
                <!-- TAB 1: Generación y descarga -->
                <div class="tab-pane fade show active" id="panel-generacion" role="tabpanel" aria-labelledby="tab-generacion">
                    <div class="accordion" id="accordionReportes">
                        <!-- Consolidado de Notas -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingConsolidado">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseConsolidado" aria-expanded="true" aria-controls="collapseConsolidado">
                                    <span class="report-icon"><i class="fas fa-journal-whills"></i></span> Consolidado de Notas
                                </button>
                            </h2>
                            <div id="collapseConsolidado" class="accordion-collapse collapse show" aria-labelledby="headingConsolidado" data-bs-parent="#accordionReportes">
                                <div class="accordion-body">
                                    <form method="get" action="${pageContext.request.contextPath}/reporte/consolidado" class="row g-3 align-items-end">
                                        <div class="col-md-3">
                                            <label class="form-label">Periodo</label>
                                            <select name="periodo" class="form-select" required>
                                                <option value="">Periodo</option>
                                                <c:forEach items="${periodos}" var="per">
                                                    <option value="${per.idPeriodo}">${per.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Mes</label>
                                            <select name="mes" class="form-select">
                                                <option value="">Mes (opcional)</option>
                                                <c:forEach items="${meses}" var="mes">
                                                    <option value="${mes.codigo}">${mes.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Nivel</label>
                                            <select name="nivel" class="form-select" required>
                                                <option value="">Nivel</option>
                                                <c:forEach items="${niveles}" var="nivel">
                                                    <option value="${nivel.idNivel}">${nivel.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Grado</label>
                                            <select name="grado" class="form-select" required>
                                                <option value="">Grado</option>
                                                <c:forEach items="${grados}" var="grado">
                                                    <option value="${grado.idGrado}">${grado.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Sección</label>
                                            <select name="seccion" class="form-select" required>
                                                <option value="">Sección</option>
                                                <c:forEach items="${secciones}" var="seccion">
                                                    <option value="${seccion.idSeccion}">${seccion.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Formato</label>
                                            <select name="formato" class="form-select" required>
                                                <option value="pdf" selected>PDF</option>
                                                <option value="excel">Excel</option>
                                                <option value="word">Word</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Tipo</label>
                                            <select name="tipo" class="form-select" required>
                                                <option value="letra">Letra</option>
                                                <option value="numerico">Numérico</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Alumno (unitario)</label>
                                            <select name="alumno" class="form-select">
                                                <option value="">Todos</option>
                                                <c:forEach items="${alumnos}" var="alumno">
                                                    <option value="${alumno.idAlumno}">${alumno.nombreCompleto}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-12 d-flex gap-2 mt-2 flex-wrap">
                                            <button type="submit" class="btn btn-admin-primary btn-uniform">
                                                <i class="fas fa-download"></i> Descargar
                                            </button>
                                            <button type="button" class="btn btn-outline-primary btn-uniform"
                                                    onclick="descargarBloque('consolidado', this.form)">
                                                <i class="fas fa-archive"></i> Bloque ZIP
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- Rendimiento Académico -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingRendimiento">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseRendimiento" aria-expanded="false" aria-controls="collapseRendimiento">
                                    <span class="report-icon"><i class="fas fa-chart-bar"></i></span> Rendimiento Académico
                                </button>
                            </h2>
                            <div id="collapseRendimiento" class="accordion-collapse collapse" aria-labelledby="headingRendimiento" data-bs-parent="#accordionReportes">
                                <div class="accordion-body">
                                    <form method="get" action="${pageContext.request.contextPath}/reporte/rendimiento" class="row g-3 align-items-end">
                                        <div class="col-md-3">
                                            <label class="form-label">Periodo</label>
                                            <select name="periodo" class="form-select" required>
                                                <option value="">Periodo</option>
                                                <c:forEach items="${periodos}" var="per">
                                                    <option value="${per.idPeriodo}">${per.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Mes</label>
                                            <select name="mes" class="form-select">
                                                <option value="">Mes (opcional)</option>
                                                <c:forEach items="${meses}" var="mes">
                                                    <option value="${mes.codigo}">${mes.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Nivel</label>
                                            <select name="nivel" class="form-select" required>
                                                <option value="">Nivel</option>
                                                <c:forEach items="${niveles}" var="nivel">
                                                    <option value="${nivel.idNivel}">${nivel.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Grado</label>
                                            <select name="grado" class="form-select" required>
                                                <option value="">Grado</option>
                                                <c:forEach items="${grados}" var="grado">
                                                    <option value="${grado.idGrado}">${grado.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Sección</label>
                                            <select name="seccion" class="form-select" required>
                                                <option value="">Sección</option>
                                                <c:forEach items="${secciones}" var="seccion">
                                                    <option value="${seccion.idSeccion}">${seccion.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <input type="hidden" name="formato" value="pdf" />
                                        <div class="col-md-4">
                                            <label class="form-label">Alumno (unitario)</label>
                                            <select name="alumno" class="form-select">
                                                <option value="">Todos</option>
                                                <c:forEach items="${alumnos}" var="alumno">
                                                    <option value="${alumno.idAlumno}">${alumno.nombreCompleto}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-12 d-flex gap-2 mt-2 flex-wrap">
                                            <button type="submit" class="btn btn-admin-primary btn-uniform">
                                                <i class="fas fa-download"></i> Descargar
                                            </button>
                                            <button type="button" class="btn btn-outline-primary btn-uniform"
                                                    onclick="descargarBloque('rendimiento', this.form)">
                                                <i class="fas fa-archive"></i> Bloque ZIP
                                            </button>
                                            <button type="button" class="btn btn-outline-success btn-uniform"
                                                    onclick="enviarBoletasPorCorreo(this.form)">
                                                <i class="fas fa-envelope"></i> Enviar a Apoderados
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- Asistencia -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingAsistencia">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseAsistencia" aria-expanded="false" aria-controls="collapseAsistencia">
                                    <span class="report-icon"><i class="fas fa-calendar-check"></i></span> Asistencia
                                </button>
                            </h2>
                            <div id="collapseAsistencia" class="accordion-collapse collapse" aria-labelledby="headingAsistencia" data-bs-parent="#accordionReportes">
                                <div class="accordion-body">
                                    <form method="get" action="${pageContext.request.contextPath}/reporte/asistencia" class="row g-3 align-items-end">
                                        <div class="col-md-3">
                                            <label class="form-label">Periodo</label>
                                            <select name="periodo" class="form-select" required>
                                                <option value="">Periodo</option>
                                                <c:forEach items="${periodos}" var="per">
                                                    <option value="${per.idPeriodo}">${per.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Mes</label>
                                            <select name="mes" class="form-select">
                                                <option value="">Mes (opcional)</option>
                                                <c:forEach items="${meses}" var="mes">
                                                    <option value="${mes.codigo}">${mes.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Nivel</label>
                                            <select name="nivel" class="form-select" required>
                                                <option value="">Nivel</option>
                                                <c:forEach items="${niveles}" var="nivel">
                                                    <option value="${nivel.idNivel}">${nivel.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Grado</label>
                                            <select name="grado" class="form-select" required>
                                                <option value="">Grado</option>
                                                <c:forEach items="${grados}" var="grado">
                                                    <option value="${grado.idGrado}">${grado.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Sección</label>
                                            <select name="seccion" class="form-select" required>
                                                <option value="">Sección</option>
                                                <c:forEach items="${secciones}" var="seccion">
                                                    <option value="${seccion.idSeccion}">${seccion.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <input type="hidden" name="formato" value="pdf" />
                                        <div class="col-md-4">
                                            <label class="form-label">Alumno (unitario)</label>
                                            <select name="alumno" class="form-select">
                                                <option value="">Todos</option>
                                                <c:forEach items="${alumnos}" var="alumno">
                                                    <option value="${alumno.idAlumno}">${alumno.nombreCompleto}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-12 d-flex gap-2 mt-2 flex-wrap">
                                            <button type="submit" class="btn btn-admin-primary btn-uniform">
                                                <i class="fas fa-download"></i> Descargar
                                            </button>
                                            <button type="button" class="btn btn-outline-primary btn-uniform"
                                                    onclick="descargarBloque('asistencia', this.form)">
                                                <i class="fas fa-archive"></i> Bloque ZIP
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- Exámenes y Evaluaciones -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingExamenes">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseExamenes" aria-expanded="false" aria-controls="collapseExamenes">
                                    <span class="report-icon"><i class="fas fa-file-alt"></i></span> Exámenes y Evaluaciones
                                </button>
                            </h2>
                            <div id="collapseExamenes" class="accordion-collapse collapse" aria-labelledby="headingExamenes" data-bs-parent="#accordionReportes">
                                <div class="accordion-body">
                                    <form method="get" action="${pageContext.request.contextPath}/reporte/examenes" class="row g-3 align-items-end">
                                        <div class="col-md-3">
                                            <label class="form-label">Periodo</label>
                                            <select name="periodo" class="form-select" required>
                                                <option value="">Periodo</option>
                                                <c:forEach items="${periodos}" var="per">
                                                    <option value="${per.idPeriodo}">${per.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Nivel</label>
                                            <select name="nivel" class="form-select" required>
                                                <option value="">Nivel</option>
                                                <c:forEach items="${niveles}" var="nivel">
                                                    <option value="${nivel.idNivel}">${nivel.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Grado</label>
                                            <select name="grado" class="form-select" required>
                                                <option value="">Grado</option>
                                                <c:forEach items="${grados}" var="grado">
                                                    <option value="${grado.idGrado}">${grado.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Sección</label>
                                            <select name="seccion" class="form-select" required>
                                                <option value="">Sección</option>
                                                <c:forEach items="${secciones}" var="seccion">
                                                    <option value="${seccion.idSeccion}">${seccion.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <input type="hidden" name="formato" value="pdf" />
                                        <div class="col-md-4">
                                            <label class="form-label">Alumno (unitario)</label>
                                            <select name="alumno" class="form-select">
                                                <option value="">Todos</option>
                                                <c:forEach items="${alumnos}" var="alumno">
                                                    <option value="${alumno.idAlumno}">${alumno.nombreCompleto}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-12 d-flex gap-2 mt-2 flex-wrap">
                                            <button type="submit" class="btn btn-admin-primary btn-uniform">
                                                <i class="fas fa-download"></i> Descargar
                                            </button>
                                            <button type="button" class="btn btn-outline-primary btn-uniform"
                                                    onclick="descargarBloque('examenes', this.form)">
                                                <i class="fas fa-archive"></i> Bloque ZIP
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- Libreta de Notas -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingLibreta">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseLibreta" aria-expanded="false" aria-controls="collapseLibreta">
                                    <span class="report-icon"><i class="fas fa-book"></i></span> Libreta de Notas
                                </button>
                            </h2>
                            <div id="collapseLibreta" class="accordion-collapse collapse" aria-labelledby="headingLibreta" data-bs-parent="#accordionReportes">
                                <div class="accordion-body">
                                    <form method="get" action="${pageContext.request.contextPath}/reporte/libreta" class="row g-3 align-items-end">
                                        <div class="col-md-3">
                                            <label class="form-label">Periodo</label>
                                            <select name="periodo" class="form-select" required>
                                                <option value="">Periodo</option>
                                                <c:forEach items="${periodos}" var="per">
                                                    <option value="${per.idPeriodo}">${per.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Nivel</label>
                                            <select name="nivel" class="form-select" required>
                                                <option value="">Nivel</option>
                                                <c:forEach items="${niveles}" var="nivel">
                                                    <option value="${nivel.idNivel}">${nivel.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Grado</label>
                                            <select name="grado" class="form-select" required>
                                                <option value="">Grado</option>
                                                <c:forEach items="${grados}" var="grado">
                                                    <option value="${grado.idGrado}">${grado.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Sección</label>
                                            <select name="seccion" class="form-select" required>
                                                <option value="">Sección</option>
                                                <c:forEach items="${secciones}" var="seccion">
                                                    <option value="${seccion.idSeccion}">${seccion.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <input type="hidden" name="formato" value="pdf" />
                                        <div class="col-md-4">
                                            <label class="form-label">Alumno (unitario)</label>
                                            <select name="alumno" class="form-select">
                                                <option value="">Todos</option>
                                                <c:forEach items="${alumnos}" var="alumno">
                                                    <option value="${alumno.idAlumno}">${alumno.nombreCompleto}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-12 d-flex gap-2 mt-2 flex-wrap">
                                            <button type="submit" class="btn btn-admin-primary btn-uniform">
                                                <i class="fas fa-download"></i> Descargar
                                            </button>
                                            <button type="button" class="btn btn-outline-primary btn-uniform"
                                                    onclick="descargarBloque('libreta', this.form)">
                                                <i class="fas fa-archive"></i> Bloque ZIP
                                            </button>
                                            <button type="button" class="btn btn-outline-success btn-uniform"
                                                    onclick="enviarBoletasPorCorreo(this.form)">
                                                <i class="fas fa-envelope"></i> Enviar a Apoderados
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- Progreso del Alumno -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingProgreso">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseProgreso" aria-expanded="false" aria-controls="collapseProgreso">
                                    <span class="report-icon"><i class="fas fa-chart-line"></i></span> Progreso del Alumno
                                </button>
                            </h2>
                            <div id="collapseProgreso" class="accordion-collapse collapse" aria-labelledby="headingProgreso" data-bs-parent="#accordionReportes">
                                <div class="accordion-body">
                                    <form method="get" action="${pageContext.request.contextPath}/reporte/progreso" class="row g-3 align-items-end">
                                        <div class="col-md-2">
                                            <label class="form-label">Nivel</label>
                                            <select name="nivel" class="form-select" required>
                                                <option value="">Nivel</option>
                                                <c:forEach items="${niveles}" var="nivel">
                                                    <option value="${nivel.idNivel}">${nivel.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Grado</label>
                                            <select name="grado" class="form-select" required>
                                                <option value="">Grado</option>
                                                <c:forEach items="${grados}" var="grado">
                                                    <option value="${grado.idGrado}">${grado.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label class="form-label">Sección</label>
                                            <select name="seccion" class="form-select" required>
                                                <option value="">Sección</option>
                                                <c:forEach items="${secciones}" var="seccion">
                                                    <option value="${seccion.idSeccion}">${seccion.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <input type="hidden" name="formato" value="pdf" />
                                        <div class="col-md-6">
                                            <label class="form-label">Alumno (obligatorio)</label>
                                            <select name="alumno" class="form-select" required>
                                                <option value="">Seleccione alumno</option>
                                                <c:forEach items="${alumnos}" var="alumno">
                                                    <option value="${alumno.idAlumno}">${alumno.nombreCompleto}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-12 d-flex gap-2 mt-2 flex-wrap">
                                            <button type="submit" class="btn btn-admin-primary btn-uniform">
                                                <i class="fas fa-download"></i> Descargar
                                            </button>
                                            <button type="button" class="btn btn-outline-primary btn-uniform"
                                                    onclick="descargarBloque('progreso', this.form)">
                                                <i class="fas fa-archive"></i> Bloque ZIP
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- TAB 2: Historial -->
                <div class="tab-pane fade" id="panel-historial" role="tabpanel" aria-labelledby="tab-historial">
                    <div class="card mt-4">
                        <div class="card-header bg-primary text-white">
                            <i class="fas fa-history"></i> Historial de Reportes Publicados
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-sm table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Tipo</th>
                                            <th>Periodo</th>
                                            <th>Nivel</th>
                                            <th>Grado</th>
                                            <th>Sección</th>
                                            <th>Fecha publicación</th>
                                            <th>Publicado por</th>
                                            <th>Acciones</th>
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
                                                    <a href="${pageContext.request.contextPath}/uploads/reportes/${rep.anio}/${rep.archivo}" target="_blank"
                                                    class="btn btn-admin-primary btn-uniform btn-sm" title="Ver">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/uploads/reportes/${rep.anio}/${rep.archivo}" download
                                                    class="btn btn-admin-primary btn-uniform btn-sm" title="Descargar">
                                                        <i class="fas fa-download"></i>
                                                    </a>
                                                    <button class="btn btn-outline-success btn-uniform btn-sm"
                                                            onclick="reenviarCorreo('${rep.id}')" title="Reenviar a apoderados">
                                                        <i class="fas fa-envelope"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty reportesPublicados}">
                                            <tr>
                                                <td colspan="8" class="text-center text-muted">No hay reportes publicados para el año seleccionado.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /tab-content -->
        </div>
    </div>
    <jsp:include page="/includes/footer.jsp" />
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/reportes.js"></script>
<script>
function cambiarAnioLectivo(select) {
    const anio = select.value;
    window.location.href = '?anio_lectivo=' + anio;
}
function descargarBloque(tipo, form) {
    let params = new URLSearchParams(new FormData(form)).toString();
    window.open(`${form.action}/bloque?${params}&tipo=${tipo}`, "_blank");
}
function reenviarCorreo(idReporte) {
    alert("Funcionalidad de reenviar pendiente de implementar para el reporte ID: " + idReporte);
}
function enviarBoletasPorCorreo(form) {
    alert("Envío de boletas a apoderados (lógica pendiente)");
}
</script>
</body>
</html>
