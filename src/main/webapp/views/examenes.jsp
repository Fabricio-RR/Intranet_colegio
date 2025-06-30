<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exámenes - Intranet Escolar</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- FullCalendar -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.0/main.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/examenes.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Gestión de Examenes-rol" scope="request" />
<c:set var="tituloPaginaMobile" value="Examnes" scope="request" />
<c:set var="iconoPagina" value="fas fa-bullhorn" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
                <!-- Filtros y Opciones -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/examenes" method="get" id="filtroForm">
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
                                                <option value="calendario" ${param.vista == 'calendario' || param.vista == null ? 'selected' : ''}>Calendario</option>
                                                <option value="lista" ${param.vista == 'lista' ? 'selected' : ''}>Lista</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="asignaturaSelect" class="form-label">Asignatura</label>
                                            <select class="form-select" id="asignaturaSelect" name="asignatura">
                                                <option value="todas" ${param.asignatura == 'todas' || param.asignatura == null ? 'selected' : ''}>Todas las asignaturas</option>
                                                <c:forEach items="${asignaturas}" var="asignatura">
                                                    <option value="${asignatura.id}" ${param.asignatura == asignatura.id ? 'selected' : ''}>${asignatura.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
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
                                            <a href="${pageContext.request.contextPath}/examenes/descargar?${pageContext.request.queryString}" class="btn btn-sm btn-outline-success" id="btnDescargar">
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

                <!-- Vista de Calendario -->
                <div class="card mb-4" id="vistaCalendario" ${param.vista == 'lista' ? 'style="display: none;"' : ''}>
                    <div class="card-header">
                        <h5 class="mb-0">Calendario de Exámenes</h5>
                    </div>
                    <div class="card-body">
                        <div id="calendario"></div>
                    </div>
                </div>

                <!-- Vista de Lista -->
                <div class="card mb-4" id="vistaLista" ${param.vista != 'lista' ? 'style="display: none;"' : ''}>
                    <div class="card-header">
                        <h5 class="mb-0">Lista de Exámenes</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Fecha</th>
                                        <th>Hora</th>
                                        <th>Asignatura</th>
                                        <th>Tipo</th>
                                        <th>Tema</th>
                                        <th>Profesor</th>
                                        <th>Aula</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${examenes}" var="examen">
                                        <tr>
                                            <td>${examen.fecha}</td>
                                            <td>${examen.hora}</td>
                                            <td>
                                                <span class="badge ${examen.asignaturaClase}">${examen.asignatura}</span>
                                            </td>
                                            <td>${examen.tipo}</td>
                                            <td>${examen.tema}</td>
                                            <td>${examen.profesor}</td>
                                            <td>${examen.aula}</td>
                                            <td>
                                                <span class="badge ${examen.estadoClase}">${examen.estado}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Próximos Exámenes -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Próximos Exámenes</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <c:forEach items="${proximosExamenes}" var="examen">
                                <div class="col-md-4 mb-4">
                                    <div class="examen-card ${examen.urgente ? 'examen-urgente' : ''}">
                                        <div class="examen-header ${examen.asignaturaClase}">
                                            <h6 class="examen-asignatura">${examen.asignatura}</h6>
                                            <span class="examen-tipo">${examen.tipo}</span>
                                        </div>
                                        <div class="examen-body">
                                            <div class="examen-fecha">
                                                <i class="fas fa-calendar-day me-2"></i>
                                                <span>${examen.fecha}</span>
                                            </div>
                                            <div class="examen-hora">
                                                <i class="fas fa-clock me-2"></i>
                                                <span>${examen.hora}</span>
                                            </div>
                                            <div class="examen-tema">
                                                <i class="fas fa-book me-2"></i>
                                                <span>${examen.tema}</span>
                                            </div>
                                            <div class="examen-profesor">
                                                <i class="fas fa-user-tie me-2"></i>
                                                <span>${examen.profesor}</span>
                                            </div>
                                            <div class="examen-aula">
                                                <i class="fas fa-door-open me-2"></i>
                                                <span>${examen.aula}</span>
                                            </div>
                                        </div>
                                        <div class="examen-footer">
                                            <c:if test="${not empty examen.recursos}">
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                        <i class="fas fa-file-alt me-1"></i> Recursos
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <c:forEach items="${examen.recursos}" var="recurso">
                                                            <li>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/recursos/${recurso.url}" target="_blank">
                                                                    <i class="${recurso.icono} me-2"></i>${recurso.nombre}
                                                                </a>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </div>
                                            </c:if>
                                            <span class="badge ${examen.estadoClase}">${examen.estado}</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Guías de Estudio -->
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Guías de Estudio</h5>
                        <button class="btn btn-sm btn-outline-secondary" type="button" data-bs-toggle="collapse" data-bs-target="#collapseGuias" aria-expanded="false" aria-controls="collapseGuias">
                            <i class="fas fa-chevron-down"></i>
                        </button>
                    </div>
                    <div class="collapse" id="collapseGuias">
                        <div class="card-body">
                            <div class="row">
                                <c:forEach items="${guiasEstudio}" var="guia">
                                    <div class="col-md-6 mb-3">
                                        <div class="guia-card">
                                            <div class="guia-header">
                                                <h6 class="guia-titulo">${guia.titulo}</h6>
                                                <span class="badge ${guia.asignaturaClase}">${guia.asignatura}</span>
                                            </div>
                                            <div class="guia-body">
                                                <p class="guia-descripcion">${guia.descripcion}</p>
                                                <div class="guia-info">
                                                    <span><i class="fas fa-user me-1"></i> ${guia.profesor}</span>
                                                    <span><i class="fas fa-calendar me-1"></i> ${guia.fecha}</span>
                                                </div>
                                            </div>
                                            <div class="guia-footer">
                                                <a href="${pageContext.request.contextPath}/recursos/${guia.url}" class="btn btn-sm btn-outline-primary" target="_blank">
                                                    <i class="fas fa-download me-1"></i> Descargar
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Consejos y Recomendaciones -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Consejos y Recomendaciones</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <c:forEach items="${consejos}" var="consejo">
                                <div class="col-md-4 mb-3">
                                    <div class="consejo-card">
                                        <div class="consejo-icon">
                                            <i class="${consejo.icono}"></i>
                                        </div>
                                        <h6 class="consejo-titulo">${consejo.titulo}</h6>
                                        <p class="consejo-texto">${consejo.texto}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <jsp:include page="/includes/footer.jsp" />
            </main>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- FullCalendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.0/main.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.0/locales/es.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/examenes.js"></script>
    
    <script>
        // Datos para el calendario (pasados desde el servidor)
        const eventosCalendario = ${eventosCalendarioJson};
        
        document.addEventListener('DOMContentLoaded', function() {
            // Inicializar calendario
            initCalendar(eventosCalendario);
            
            // Manejar filtros
            document.getElementById('btnAplicarFiltros').addEventListener('click', function() {
                document.getElementById('filtroForm').submit();
            });
            
            // Manejar cambio de vista
            document.getElementById('vistaSelect').addEventListener('change', function() {
                const vista = this.value;
                
                if (vista === 'calendario') {
                    document.getElementById('vistaCalendario').style.display = 'block';
                    document.getElementById('vistaLista').style.display = 'none';
                } else if (vista === 'lista') {
                    document.getElementById('vistaCalendario').style.display = 'none';
                    document.getElementById('vistaLista').style.display = 'block';
                }
            });
            
            // Manejar botón de imprimir
            document.getElementById('btnImprimir').addEventListener('click', function() {
                window.print();
            });
        });
        
        function initCalendar(eventos) {
            const calendarEl = document.getElementById('calendario');
            
            const calendar = new FullCalendar.Calendar(calendarEl, {
                locale: 'es',
                initialView: 'dayGridMonth',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,listWeek'
                },
                events: eventos,
                eventClick: function(info) {
                    showExamenDetails(info.event);
                },
                height: 'auto'
            });
            
            calendar.render();
        }
        
        function showExamenDetails(event) {
            // Implementar lógica para mostrar detalles del examen
            // Por ejemplo, abrir un modal con la información completa
            console.log('Examen seleccionado:', event.title);
        }
    </script>
</body>
</html>