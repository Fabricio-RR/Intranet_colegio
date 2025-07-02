<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Notas" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Registro de Notas - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/dashboard.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        .nota-retirado { background-color: #e0e0e0 !important; color: #888 !important; }
        .nota-exonerado { background-color: #26de81 !important; color: #fff !important; }
        .criterio-calculado-mensual { background: #ffeaa7 !important; font-weight: bold; }
        .criterio-calculado-bimestral { background: #fff944 !important; font-weight: bold; }
        .nota-baja { color: #e74c3c; font-weight: bold; }
        .nota-alta { color: #0984e3; font-weight: bold; }
        .table-notas th, .table-notas td { text-align: center; vertical-align: middle; }
        .table-notas input[type="number"] {
            width: 55px; text-align: center; border-radius: 8px; border: 1px solid #dfe6e9; padding: 3px;
        }
        .leyenda-badge { height: 18px; width: 18px; border-radius: 3px; display: inline-block; margin-right: 5px; }
    </style>
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Registro de Notas" scope="request" />
<c:set var="tituloPaginaMobile" value="Notas" scope="request" />
<c:set var="iconoPagina" value="fas fa-clipboard-list me-2" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
<div class="container-fluid px-1 px-md-1">
    <div class="d-flex align-items-center justify-content-between mt-1 mb-1">
        <h4 class="fw-bold mb-0"></h4>
        <div>
            <c:if test="${not periodoBloqueado}">
                <button class="btn btn-admin-primary me-2" type="submit" form="formNotas">
                    <i class="fas fa-save me-1"></i> Guardar
                </button>
            </c:if>
        </div>
    </div>
    <!-- Filtros en dos filas de 3 columnas cada una -->
    <form class="mb-3" method="get" action="">
        <div class="row g-2 mb-2">
            <div class="col-12 col-md-4">
                <label class="fw-semibold mb-1">Nivel</label>
                <select name="nivel" class="form-select">
                    <c:forEach items="${niveles}" var="nivel">
                        <option value="${nivel.idNivel}" ${nivel.idNivel == selectedNivel ? 'selected' : ''}>${nivel.nombre}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-12 col-md-4">
                <label class="fw-semibold mb-1">Grado</label>
                <select name="grado" class="form-select">
                    <c:forEach items="${grados}" var="grado">
                        <option value="${grado.id}" ${grado.id == selectedGrado ? 'selected' : ''}>${grado.nombre}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-12 col-md-4">
                <label class="fw-semibold mb-1">Sección</label>
                <select name="seccion" class="form-select">
                    <c:forEach items="${secciones}" var="seccion">
                        <option value="${seccion.id}" ${seccion.id == selectedSeccion ? 'selected' : ''}>${seccion.nombre}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="row g-2">
            <div class="col-12 col-md-4">
                <label class="fw-semibold mb-1">Curso</label>
                <select name="curso" class="form-select">
                    <c:forEach items="${cursos}" var="curso">
                        <option value="${curso.idCurso}" ${curso.idCurso == selectedCurso ? 'selected' : ''}>${curso.nombreCurso}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-12 col-md-4">
                <label class="fw-semibold mb-1">Periodo</label>
                <select name="periodo" class="form-select">
                    <c:forEach items="${periodos}" var="periodo">
                        <option value="${periodo.id}" ${periodo.id == selectedPeriodo ? 'selected' : ''}>${periodo.nombre}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-12 col-md-4">
                <label class="fw-semibold mb-1">Mes</label>
                <select name="mes" class="form-select">
                    <c:forEach items="${meses}" var="mes">
                        <option value="${mes.id}" ${mes.id == selectedMes ? 'selected' : ''}>${mes.nombre}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
    </form>

    <!-- Leyenda -->
    <div class="row mb-3">
        <div class="col-lg-6 col-md-8 col-12">
            <div class="card shadow-sm border-0">
                <div class="card-body p-3">
                    <h6 class="mb-3 fw-semibold"><i class="fas fa-info-circle me-2 text-primary"></i>Leyenda</h6>
                    <div class="d-flex flex-wrap gap-4">
                        <div><span class="leyenda-badge" style="background:#e0e0e0;"></span> Retirado/Trasladado</div>
                        <div><span class="leyenda-badge" style="background:#26de81;"></span> Exonerado</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tabla de Notas -->
    <form id="formNotas" method="post" action="${pageContext.request.contextPath}/notas/guardar">
    <input type="hidden" name="idCurso" value="${selectedCurso}" />
    <input type="hidden" name="idPeriodo" value="${selectedPeriodo}" />
    <input type="hidden" name="idMes" value="${selectedMes}" />

    <div class="table-responsive">
        <table class="table table-hover table-notas" id="tablaNotas">
            <thead class="table-light">
                <tr>
                    <th>#</th>
                    <th>Alumno</th>
                    <c:forEach items="${criterios}" var="criterio">
                        <th
                            class="
                                <c:if test='${criterio.calculado and criterio.tipoCalculo eq "mensual"}'>criterio-calculado-mensual</c:if>
                                <c:if test='${criterio.calculado and criterio.tipoCalculo eq "bimestral"}'>criterio-calculado-bimestral</c:if>
                            "
                            data-bs-toggle="tooltip"
                            data-bs-placement="top"
                            data-bs-title="${criterio.descripcion}">
                            <span class="d-block">${criterio.nombre}</span>
                        </th>
                    </c:forEach>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${alumnos}" var="alumno" varStatus="loop">
                    <tr class="${alumno.retirado ? 'nota-retirado' : ''} ${alumno.exonerado ? 'nota-exonerado' : ''}">
                        <td>${loop.index + 1}</td>
                        <td class="text-start fw-semibold">${alumno.nombreCompleto}</td>
                        <c:forEach items="${alumno.notas}" var="nota" varStatus="cIdx">
                            <td
                                class="
                                    <c:if test='${criterios[cIdx.index].calculado and criterios[cIdx.index].tipoCalculo eq "mensual"}'>criterio-calculado-mensual</c:if>
                                    <c:if test='${criterios[cIdx.index].calculado and criterios[cIdx.index].tipoCalculo eq "bimestral"}'>criterio-calculado-bimestral</c:if>
                                ">
                                <input type="number" min="0" max="20"
                                    class="form-control form-control-sm nota-editable ${nota.valor < 11 ? 'nota-baja' : (nota.valor >= 17 ? 'nota-alta' : '')}"
                                    name="nota_${alumno.id}_${nota.idCriterio}"
                                    value="${nota.valor}"
                                    <c:if test="${alumno.retirado || alumno.exonerado || periodoBloqueado || criterios[cIdx.index].calculado}">readonly</c:if> />
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    </form>
</div>
<jsp:include page="/includes/footer.jsp" />
</main>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script>
    $(document).ready(function(){
        $('#tablaNotas').DataTable({
            language: {
                url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
            },
            responsive: true,
            paging: false,
            searching: false,
            info: false,
            ordering: false,
            scrollX: true
        });
        // Activar tooltips Bootstrap
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        tooltipTriggerList.forEach(function (tooltipTriggerEl) {
            new bootstrap.Tooltip(tooltipTriggerEl)
        });
    });
</script>
</body>
</html>
