<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Horario - Intranet Escolar</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/horario.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="/includes/sidebar.jsp" />

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <jsp:include page="/includes/header.jsp" />

                <!-- Filtros y Opciones -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/horario" method="get" id="filtroForm">
                                    <div class="row">
                                        <div class="col-md-4 mb-3 mb-md-0">
                                            <label for="periodoSelect" class="form-label">Periodo</label>
                                            <select class="form-select" id="periodoSelect" name="periodo">
                                                <option value="actual" ${param.periodo == 'actual' || param.periodo == null ? 'selected' : ''}>Periodo Actual</option>
                                                <c:forEach items="${periodos}" var="periodo">
                                                    <option value="${periodo.id}" ${param.periodo == periodo.id ? 'selected' : ''}>${periodo.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4 mb-3 mb-md-0">
                                            <label for="vistaSelect" class="form-label">Vista</label>
                                            <select class="form-select" id="vistaSelect" name="vista">
                                                <option value="semanal" ${param.vista == 'semanal' || param.vista == null ? 'selected' : ''}>Semanal</option>
                                                <option value="diaria" ${param.vista == 'diaria' ? 'selected' : ''}>Diaria</option>
                                                <option value="lista" ${param.vista == 'lista' ? 'selected' : ''}>Lista</option>
                                            </select>
                                        </div>
                                        <c:if test="${sessionScope.usuario.rol eq 'ADMIN' || sessionScope.usuario.rol eq 'DOCENTE' || sessionScope.usuario.rol eq 'APODERADO'}">
                                            <div class="col-md-4">
                                                <label for="grupoSelect" class="form-label">Grupo</label>
                                                <select class="form-select" id="grupoSelect" name="grupo">
                                                    <c:forEach items="${grupos}" var="grupo">
                                                        <option value="${grupo.id}" ${param.grupo == grupo.id ? 'selected' : ''}>${grupo.nombre}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </c:if>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <label class="form-label">Acciones</label>
                                        <div>
                                            <button class="btn btn-sm btn-outline-primary me-2" id="btnImprimir">
                                                <i class="fas fa-print me-1"></i> Imprimir
                                            </button>
                                            <a href="${pageContext.request.contextPath}/horario/descargar?${pageContext.request.queryString}" class="btn btn-sm btn-outline-success" id="btnDescargar">
                                                <i class="fas fa-download me-1"></i> Descargar
                                            </a>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <button class="btn btn-sm btn-outline-secondary" id="btnAplicarFiltros">
                                            <i class="fas fa-filter me-1"></i> Aplicar
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Vista Semanal del Horario -->
                <div class="card mb-4" id="vistaSemanal" ${param.vista == 'diaria' || param.vista == 'lista' ? 'style="display: none;"' : ''}>
                    <div class="card-header">
                        <h5 class="mb-0">Horario Semanal - ${grupoActual.nombre}</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered horario-table">
                                <thead>
                                    <tr>
                                        <th class="hora-column">Hora</th>
                                        <th>Lunes</th>
                                        <th>Martes</th>
                                        <th>Miércoles</th>
                                        <th>Jueves</th>
                                        <th>Viernes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${horarioSemanal}" var="hora">
                                        <tr>
                                            <td class="hora-column">
                                                <div class="hora-info">
                                                    <span class="hora-rango">${hora.horaInicio} - ${hora.horaFin}</span>
                                                    <span class="hora-numero">${hora.numero}</span>
                                                </div>
                                            </td>
                                            <c:forEach items="${hora.dias}" var="dia">
                                                <c:choose>
                                                    <c:when test="${dia.esReceso}">
                                                        <td class="receso">
                                                            <div class="receso-info">
                                                                <h6>Receso</h6>
                                                            </div>
                                                        </td>
                                                    </c:when>
                                                    <c:when test="${not empty dia.materia}">
                                                        <td class="materia ${dia.materiaClase}">
                                                            <div class="materia-info">
                                                                <h6 class="materia-nombre">${dia.materia}</h6>
                                                                <p class="materia-profesor">${dia.profesor}</p>
                                                                <p class="materia-aula">${dia.aula}</p>
                                                            </div>
                                                        </td>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <td></td>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Vista Diaria del Horario -->
                <div class="card mb-4" id="vistaDiaria" ${param.vista != 'diaria' ? 'style="display: none;"' : ''}>
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Horario Diario - ${grupoActual.nombre}</h5>
                        <div class="btn-group">
                            <button class="btn btn-sm btn-outline-primary" id="btnDiaAnterior">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button class="btn btn-sm btn-outline-secondary" id="btnDiaActual">
                                Hoy
                            </button>
                            <button class="btn btn-sm btn-outline-primary" id="btnDiaSiguiente">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <h4 class="text-center mb-4" id="fechaDiaria">${fechaDiaria}</h4>
                        <div class="table-responsive">
                            <table class="table table-bordered horario-table">
                                <thead>
                                    <tr>
                                        <th class="hora-column">Hora</th>
                                        <th>Materia</th>
                                        <th>Profesor</th>
                                        <th>Aula</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${horarioDiario}" var="clase">
                                        <tr>
                                            <td class="hora-column">
                                                <div class="hora-info">
                                                    <span class="hora-rango">${clase.horaInicio} - ${clase.horaFin}</span>
                                                    <span class="hora-numero">${clase.numero}</span>
                                                </div>
                                            </td>
                                            <c:choose>
                                                <c:when test="${clase.esReceso}">
                                                    <td colspan="3" class="receso">
                                                        <div class="receso-info">
                                                            <h6>Receso</h6>
                                                        </div>
                                                    </td>
                                                </c:when>
                                                <c:when test="${not empty clase.materia}">
                                                    <td class="${clase.materiaClase}">${clase.materia}</td>
                                                    <td>${clase.profesor}</td>
                                                    <td>${clase.aula}</td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td colspan="3" class="text-center text-muted">No hay clase programada</td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Vista de Lista del Horario -->
                <div class="card mb-4" id="vistaLista" ${param.vista != 'lista' ? 'style="display: none;"' : ''}>
                    <div class="card-header">
                        <h5 class="mb-0">Lista de Clases - ${grupoActual.nombre}</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Día</th>
                                        <th>Hora</th>
                                        <th>Materia</th>
                                        <th>Profesor</th>
                                        <th>Aula</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${horarioLista}" var="clase">
                                        <tr>
                                            <td>${clase.dia}</td>
                                            <td>${clase.horaInicio} - ${clase.horaFin}</td>
                                            <td>
                                                <span class="badge ${clase.materiaClase}">${clase.materia}</span>
                                            </td>
                                            <td>${clase.profesor}</td>
                                            <td>${clase.aula}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Información Adicional -->
                <div class="row">
                    <!-- Leyenda de Materias -->
                    <div class="col-md-6 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="mb-0">Leyenda de Materias</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <c:forEach items="${materias}" var="materia" varStatus="status">
                                        <div class="col-md-6">
                                            <div class="leyenda-item">
                                                <div class="leyenda-color ${materia.clase}"></div>
                                                <span class="leyenda-texto">${materia.nombre}</span>
                                            </div>
                                        </div>
                                        <c:if test="${status.count % 4 == 0}">
                                            </div><div class="row">
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Información de Profesores -->
                    <div class="col-md-6 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="mb-0">Información de Profesores</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Profesor</th>
                                                <th>Materia</th>
                                                <th>Contacto</th>
                                                <th>Acción</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${profesores}" var="profesor">
                                                <tr>
                                                    <td>${profesor.nombre}</td>
                                                    <td>${profesor.materia}</td>
                                                    <td>${profesor.email}</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/mensajes/nuevo?destinatario=${profesor.id}" class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-envelope"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Notas y Recordatorios -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Notas y Recordatorios</h5>
                    </div>
                    <div class="card-body">
                        <c:forEach items="${notas}" var="nota">
                            <div class="alert alert-${nota.tipo} mb-3">
                                <h6 class="alert-heading"><i class="${nota.icono} me-2"></i>${nota.titulo}</h6>
                                <p class="mb-0">${nota.mensaje}</p>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <jsp:include page="/includes/footer.jsp" />
            </main>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/horario.js"></script>
</body>
</html>