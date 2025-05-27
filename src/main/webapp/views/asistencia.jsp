<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Asistencia - Intranet Escolar</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #110D59;
            --secondary-color: #F70617;
            --primary-hover: #1a1685;
            --secondary-hover: #d10513;
        }
        
        .wrapper {
            display: flex;
            width: 100%;
            min-height: 100vh;
        }
        
        .sidebar {
            width: 250px;
            background-color: var(--primary-color);
            color: white;
            transition: all 0.3s;
        }
        
        .sidebar.collapsed {
            margin-left: -250px;
        }
        
        .content {
            width: calc(100% - 250px);
            transition: all 0.3s;
        }
        
        .content.expanded {
            width: 100%;
        }
        
        .page-title {
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .card-header {
            background-color: var(--primary-color);
            color: white;
        }
        
        .badge.bg-danger {
            background-color: var(--secondary-color) !important;
        }
        
        .asistencia-card {
            transition: transform 0.3s ease;
            margin-bottom: 20px;
        }
        
        .asistencia-card:hover {
            transform: translateY(-5px);
        }
        
        .calendar-container {
            margin-bottom: 30px;
        }
        
        .calendar-day {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin: 5px;
            font-weight: 500;
        }
        
        .calendar-day.asistio {
            background-color: #198754;
            color: white;
        }
        
        .calendar-day.falta {
            background-color: var(--secondary-color);
            color: white;
        }
        
        .calendar-day.tardanza {
            background-color: #ffc107;
            color: black;
        }
        
        .calendar-day.justificada {
            background-color: #0dcaf0;
            color: white;
        }
        
        .calendar-day.today {
            border: 2px solid var(--primary-color);
        }
        
        .calendar-day:hover {
            cursor: pointer;
            opacity: 0.8;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            margin-right: 15px;
            margin-bottom: 10px;
        }
        
        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .asistencia-stats {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .stat-card {
            flex: 1;
            min-width: 200px;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .stat-icon {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        
        .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .filter-container {
            margin-bottom: 20px;
        }
        
        .month-selector {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .navbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .navbar-brand {
            color: var(--primary-color);
            font-weight: bold;
        }
        
        .navbar-toggler {
            border: none;
        }
        
        .dropdown-menu {
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .dropdown-item:hover {
            background-color: var(--light-gray);
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        
        .modal-header {
            background-color: var(--primary-color);
            color: white;
        }
        
        .modal-header .close {
            color: white;
        }
        
        @media (max-width: 768px) {
            .sidebar {
                margin-left: -250px;
            }
            
            .sidebar.active {
                margin-left: 0;
            }
            
            .content {
                width: 100%;
            }
            
            .asistencia-stats {
                flex-direction: column;
            }
            
            .stat-card {
                min-width: 100%;
            }
            
            .calendar-day {
                width: 35px;
                height: 35px;
                margin: 3px;
                font-size: 0.9rem;
            }
            
            .legend-container {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <!-- Sidebar -->
        <c:choose>
            <c:when test="${usuario.rol.nombre eq 'ALUMNO'}">
                <jsp:include page="/WEB-INF/views/alumno/sidebar.jsp" />
            </c:when>
            <c:when test="${usuario.rol.nombre eq 'APODERADO'}">
                <jsp:include page="/WEB-INF/views/apoderado/sidebar.jsp" />
            </c:when>
            <c:when test="${usuario.rol.nombre eq 'DOCENTE'}">
                <jsp:include page="/WEB-INF/views/docente/sidebar.jsp" />
            </c:when>
        </c:choose>
        
        <!-- Page Content -->
        <div class="content">
            <!-- Navbar -->
            <c:choose>
                <c:when test="${usuario.rol.nombre eq 'ALUMNO'}">
                    <jsp:include page="/WEB-INF/views/alumno/navbar.jsp" />
                </c:when>
                <c:when test="${usuario.rol.nombre eq 'APODERADO'}">
                    <jsp:include page="/WEB-INF/views/apoderado/navbar.jsp" />
                </c:when>
                <c:when test="${usuario.rol.nombre eq 'DOCENTE'}">
                    <jsp:include page="/WEB-INF/views/docente/navbar.jsp" />
                </c:when>
            </c:choose>
            
            <!-- Main Content -->
            <div class="container-fluid p-4">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h2 class="page-title">Control de Asistencia</h2>
                        <c:if test="${usuario.rol.nombre eq 'APODERADO' && not empty alumno}">
                            <p class="text-muted">Estudiante: ${alumno.nombres} ${alumno.apellidos} | ${alumno.grado.nombre} ${alumno.seccion.nombre}</p>
                        </c:if>
                        <c:if test="${usuario.rol.nombre eq 'ALUMNO'}">
                            <p class="text-muted">Estudiante: ${usuario.nombres} ${usuario.apellidos} | ${usuario.grado.nombre} ${usuario.seccion.nombre}</p>
                        </c:if>
                        <c:if test="${usuario.rol.nombre eq 'DOCENTE'}">
                            <p class="text-muted">Docente: ${usuario.nombres} ${usuario.apellidos}</p>
                        </c:if>
                    </div>
                </div>
                
                <!-- Filtros -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card shadow">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="filtroPeriodo" class="form-label">Periodo</label>
                                            <select class="form-control" id="filtroPeriodo">
                                                <option value="todos" selected>Año Lectivo 2023</option>
                                                <option value="1">Primer Bimestre</option>
                                                <option value="2">Segundo Bimestre</option>
                                                <option value="3">Tercer Bimestre</option>
                                                <option value="4">Cuarto Bimestre</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="filtroMes" class="form-label">Mes</label>
                                            <select class="form-control" id="filtroMes">
                                                <option value="todos" selected>Todos los meses</option>
                                                <option value="1">Enero</option>
                                                <option value="2">Febrero</option>
                                                <option value="3">Marzo</option>
                                                <option value="4">Abril</option>
                                                <option value="5">Mayo</option>
                                                <option value="6">Junio</option>
                                                <option value="7">Julio</option>
                                                <option value="8">Agosto</option>
                                                <option value="9">Septiembre</option>
                                                <option value="10">Octubre</option>
                                                <option value="11">Noviembre</option>
                                                <option value="12">Diciembre</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="filtroRango" class="form-label">Rango de fechas</label>
                                            <input type="text" class="form-control" id="filtroRango" placeholder="Seleccionar rango">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Estadísticas de Asistencia -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold">Resumen de Asistencia</h6>
                                <div class="dropdown no-arrow">
                                    <a class="dropdown-toggle text-white" href="#" role="button" id="dropdownMenuLink"
                                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fas fa-ellipsis-v fa-sm fa-fw"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in"
                                        aria-labelledby="dropdownMenuLink">
                                        <div class="dropdown-header">Opciones:</div>
                                        <a class="dropdown-item" href="#" id="btnExportarPDF">
                                            <i class="fas fa-file-pdf mr-2"></i>Exportar a PDF
                                        </a>
                                        <a class="dropdown-item" href="#" id="btnExportarExcel">
                                            <i class="fas fa-file-excel mr-2"></i>Exportar a Excel
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="asistencia-stats">
                                    <div class="stat-card bg-white">
                                        <div class="stat-icon text-primary">
                                            <i class="fas fa-calendar-check"></i>
                                        </div>
                                        <div class="stat-value">98%</div>
                                        <div class="stat-label">Porcentaje de Asistencia</div>
                                    </div>
                                    
                                    <div class="stat-card bg-white">
                                        <div class="stat-icon text-success">
                                            <i class="fas fa-check-circle"></i>
                                        </div>
                                        <div class="stat-value">120</div>
                                        <div class="stat-label">Días Asistidos</div>
                                    </div>
                                    
                                    <div class="stat-card bg-white">
                                        <div class="stat-icon" style="color: var(--secondary-color);">
                                            <i class="fas fa-times-circle"></i>
                                        </div>
                                        <div class="stat-value">2</div>
                                        <div class="stat-label">Faltas</div>
                                    </div>
                                    
                                    <div class="stat-card bg-white">
                                        <div class="stat-icon text-warning">
                                            <i class="fas fa-clock"></i>
                                        </div>
                                        <div class="stat-value">3</div>
                                        <div class="stat-label">Tardanzas</div>
                                    </div>
                                    
                                    <div class="stat-card bg-white">
                                        <div class="stat-icon text-info">
                                            <i class="fas fa-file-medical"></i>
                                        </div>
                                        <div class="stat-value">1</div>
                                        <div class="stat-label">Faltas Justificadas</div>
                                    </div>
                                </div>
                                
                                <div class="progress mb-4" style="height: 25px;">
                                    <div class="progress-bar bg-success" role="progressbar" style="width: 92%;" aria-valuenow="92" aria-valuemin="0" aria-valuemax="100">92%</div>
                                    <div class="progress-bar bg-info" role="progressbar" style="width: 3%;" aria-valuenow="3" aria-valuemin="0" aria-valuemax="100">3%</div>
                                    <div class="progress-bar bg-warning" role="progressbar" style="width: 3%;" aria-valuenow="3" aria-valuemin="0" aria-valuemax="100">3%</div>
                                    <div class="progress-bar" role="progressbar" style="width: 2%; background-color: var(--secondary-color);" aria-valuenow="2" aria-valuemin="0" aria-valuemax="100">2%</div>
                                </div>
                                
                                <div class="d-flex flex-wrap legend-container">
                                    <div class="legend-item">
                                        <div class="legend-color" style="background-color: #198754;"></div>
                                        <span>Asistencia</span>
                                    </div>
                                    <div class="legend-item">
                                        <div class="legend-color" style="background-color: #0dcaf0;"></div>
                                        <span>Falta Justificada</span>
                                    </div>
                                    <div class="legend-item">
                                        <div class="legend-color" style="background-color: #ffc107;"></div>
                                        <span>Tardanza</span>
                                    </div>
                                    <div class="legend-item">
                                        <div class="legend-color" style="background-color: var(--secondary-color);"></div>
                                        <span>Falta</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Calendario de Asistencia -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold">Calendario de Asistencia</h6>
                            </div>
                            <div class="card-body">
                                <div class="month-selector">
                                    <button class="btn btn-sm btn-outline-secondary" id="prevMonth">
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                    <h5 class="mb-0" id="currentMonth">Julio 2023</h5>
                                    <button class="btn btn-sm btn-outline-secondary" id="nextMonth">
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                </div>
                                
                                <div class="calendar-container">
                                    <div class="d-flex justify-content-center mb-2">
                                        <div class="calendar-day">Lu</div>
                                        <div class="calendar-day">Ma</div>
                                        <div class="calendar-day">Mi</div>
                                        <div class="calendar-day">Ju</div>
                                        <div class="calendar-day">Vi</div>
                                        <div class="calendar-day">Sa</div>
                                        <div class="calendar-day">Do</div>
                                    </div>
                                    <div class="d-flex justify-content-center flex-wrap" id="calendarDays">
                                        <!-- Los días se generarán dinámicamente con JavaScript -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Detalle de Asistencia -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold">Detalle de Asistencia</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered" id="tablaAsistencia" width="100%" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th>Fecha</th>
                                                <th>Estado</th>
                                                <th>Hora de Entrada</th>
                                                <th>Hora de Salida</th>
                                                <th>Observaciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>01/07/2023</td>
                                                <td><span class="badge badge-success">Asistió</span></td>
                                                <td>07:45 AM</td>
                                                <td>03:15 PM</td>
                                                <td>-</td>
                                            </tr>
                                            <tr>
                                                <td>02/07/2023</td>
                                                <td><span class="badge badge-secondary">Domingo</span></td>
                                                <td>-</td>
                                                <td>-</td>
                                                <td>-</td>
                                            </tr>
                                            <tr>
                                                <td>03/07/2023</td>
                                                <td><span class="badge badge-success">Asistió</span></td>
                                                <td>07:50 AM</td>
                                                <td>03:15 PM</td>
                                                <td>-</td>
                                            </tr>
                                            <tr>
                                                <td>04/07/2023</td>
                                                <td><span class="badge badge-success">Asistió</span></td>
                                                <td>07:45 AM</td>
                                                <td>03:15 PM</td>
                                                <td>-</td>
                                            </tr>
                                            <tr>
                                                <td>05/07/2023</td>
                                                <td><span class="badge badge-warning">Tardanza</span></td>
                                                <td>08:10 AM</td>
                                                <td>03:15 PM</td>
                                                <td>Llegó 10 minutos tarde</td>
                                            </tr>
                                            <tr>
                                                <td>06/07/2023</td>
                                                <td><span class="badge badge-success">Asistió</span></td>
                                                <td>07:45 AM</td>
                                                <td>03:15 PM</td>
                                                <td>-</td>
                                            </tr>
                                            <tr>
                                                <td>07/07/2023</td>
                                                <td><span class="badge badge-success">Asistió</span></td>
                                                <td>07:50 AM</td>
                                                <td>03:15 PM</td>
                                                <td>-</td>
                                            </tr>
                                            <tr>
                                                <td>08/07/2023</td>
                                                <td><span class="badge badge-secondary">Sábado</span></td>
                                                <td>-</td>
                                                <td>-</td>
                                                <td>-</td>
                                            </tr>
                                            <tr>
                                                <td>09/07/2023</td>
                                                <td><span class="badge badge-secondary">Domingo</span></td>
                                                <td>-</td>
                                                <td>-</td>
                                                <td>-</td>
                                            </tr>
                                            <tr>
                                                <td>10/07/2023</td>
                                                <td><span class="badge badge-danger">Falta</span></td>
                                                <td>-</td>
                                                <td>-</td>
                                                <td>No asistió</td>
                                            </tr>
                                            <tr>
                                                <td>11/07/2023</td>
                                                <td><span class="badge badge-info">Justificada</span></td>
                                                <td>-</td>
                                                <td>-</td>
                                                <td>Presentó certificado médico</td>
                                            </tr>
                                            <tr>
                                                <td>12/07/2023</td>
                                                <td><span class="badge badge-success">Asistió</span></td>
                                                <td>07:45 AM</td>
                                                <td>03:15 PM</td>
                                                <td>-</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Footer -->
            <c:choose>
                <c:when test="${usuario.rol.nombre eq 'ALUMNO'}">
                    <jsp:include page="/WEB-INF/views/alumno/footer.jsp" />
                </c:when>
                <c:when test="${usuario.rol.nombre eq 'APODERADO'}">
                    <jsp:include page="/WEB-INF/views/apoderado/footer.jsp" />
                </c:when>
                <c:when test="${usuario.rol.nombre eq 'DOCENTE'}">
                    <jsp:include page="/WEB-INF/views/docente/footer.jsp" />
                </c:when>
            </c:choose>
        </div>
    </div>
    
    <!-- Modal de Detalle de Asistencia -->
    <div class="modal fade" id="asistenciaModal" tabindex="-1" aria-labelledby="asistenciaModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="asistenciaModalLabel">Detalle de Asistencia</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <h5 id="modalFecha">10 de Julio, 2023</h5>
                        <p class="text-muted" id="modalEstado">Estado: Falta</p>
                    </div>
                    <div class="mb-3">
                        <p><strong>Hora de Entrada:</strong> <span id="modalEntrada">-</span></p>
                        <p><strong>Hora de Salida:</strong> <span id="modalSalida">-</span></p>
                        <p><strong>Observaciones:</strong> <span id="modalObservaciones">No asistió</span></p>
                    </div>
                    <div id="modalJustificacion" style="display: none;">
                        <h6>Justificación</h6>
                        <p id="modalJustificacionTexto">Presentó certificado médico por enfermedad.</p>
                        <p><strong>Fecha de Justificación:</strong> <span id="modalJustificacionFecha">11/07/2023</span></p>
                        <p><strong>Aprobado por:</strong> <span id="modalJustificacionAprobador">María López (Coordinadora)</span></p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                    <c:if test="${usuario.rol.nombre eq 'APODERADO'}">
                        <button type="button" class="btn btn-danger" id="btnJustificar">Justificar Falta</button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.22/js/dataTables.bootstrap4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>
    <script>
        $(document).ready(function() {
            // Inicializar DataTable
            $('#tablaAsistencia').DataTable({
                language: {
                    url: '${pageContext.request.contextPath}/assets/js/dataTables.spanish.json'
                },
                pageLength: 10,
                responsive: true,
                order: [[0, 'desc']]
            });
            
            // Inicializar Flatpickr para el selector de rango de fechas
            flatpickr("#filtroRango", {
                mode: "range",
                dateFormat: "d/m/Y",
                locale: "es",
                altInput: true,
                altFormat: "j F, Y",
                rangeSeparator: " al "
            });
            
            // Generar calendario
            function generateCalendar(year, month) {
                const firstDay = new Date(year, month, 1);
                const lastDay = new Date(year, month + 1, 0);
                const daysInMonth = lastDay.getDate();
                const startingDay = firstDay.getDay() || 7; // Convertir 0 (domingo) a 7
                
                // Actualizar título del mes
                const monthNames = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
                $('#currentMonth').text(monthNames[month] + ' ' + year);
                
                // Limpiar días anteriores
                $('#calendarDays').empty();
                
                // Agregar espacios en blanco para los días anteriores al primer día del mes
                for (let i = 1; i < startingDay; i++) {
                    $('#calendarDays').append('<div class="calendar-day"></div>');
                }
                
                // Datos de ejemplo para la asistencia
                const asistencia = {
                    1: 'asistio',
                    2: 'asistio',
                    3: 'asistio',
                    4: 'asistio',
                    5: 'tardanza',
                    6: 'asistio',
                    7: 'asistio',
                    10: 'falta',
                    11: 'justificada',
                    12: 'asistio',
                    13: 'asistio',
                    14: 'asistio',
                    15: 'asistio',
                    16: 'asistio',
                    17: 'asistio',
                    18: 'asistio',
                    19: 'asistio',
                    20: 'tardanza',
                    21: 'asistio',
                    24: 'asistio',
                    25: 'asistio',
                    26: 'asistio',
                    27: 'asistio',
                    28: 'tardanza',
                    31: 'asistio'
                };
                
                const today = new Date();
                const isCurrentMonth = today.getFullYear() === year && today.getMonth() === month;
                const currentDate = today.getDate();
                
                // Agregar los días del mes
                for (let i = 1; i <= daysInMonth; i++) {
                    const isToday = isCurrentMonth && i === currentDate;
                    const estado = asistencia[i] || '';
                    
                    let dayClass = 'calendar-day';
                    if (estado) dayClass += ' ' + estado;
                    if (isToday) dayClass += ' today';
                    
                    const dayElement = $(`<div class="${dayClass}" data-date="${i}/${month+1}/${year}" data-estado="${estado}">${i}</div>`);
                    
                    // Agregar evento click para mostrar detalle
                    dayElement.click(function() {
                        const date = $(this).data('date');
                        const estado = $(this).data('estado');
                        showAsistenciaDetail(date, estado);
                    });
                    
                    $('#calendarDays').append(dayElement);
                }
            }
            
            // Mostrar detalle de asistencia en modal
            function showAsistenciaDetail(date, estado) {
                // Formatear fecha
                const dateParts = date.split('/');
                const formattedDate = new Date(dateParts[2], dateParts[1] - 1, dateParts[0]);
                const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                const formattedDateStr = formattedDate.toLocaleDateString('es-ES', options);
                
                // Capitalizar primera letra
                const formattedDateCapitalized = formattedDateStr.charAt(0).toUpperCase() + formattedDateStr.slice(1);
                
                $('#modalFecha').text(formattedDateCapitalized);
                
                // Establecer estado y detalles según el tipo de asistencia
                let estadoText = '';
                let entrada = '-';
                let salida = '-';
                let observaciones = '-';
                
                switch(estado) {
                    case 'asistio':
                        estadoText = '<span class="badge badge-success">Asistió</span>';
                        entrada = '07:45 AM';
                        salida = '03:15 PM';
                        break;
                    case 'tardanza':
                        estadoText = '<span class="badge badge-warning">Tardanza</span>';
                        entrada = '08:10 AM';
                        salida = '03:15 PM';
                        observaciones = 'Llegó 10 minutos tarde';
                        break;
                    case 'falta':
                        estadoText = '<span class="badge badge-danger">Falta</span>';
                        observaciones = 'No asistió';
                        break;
                    case 'justificada':
                        estadoText = '<span class="badge badge-info">Justificada</span>';
                        observaciones = 'Presentó certificado médico';
                        $('#modalJustificacion').show();
                        break;
                    default:
                        estadoText = '<span class="badge badge-secondary">No hay clases</span>';
                }
                
                $('#modalEstado').html('Estado: ' + estadoText);
                $('#modalEntrada').text(entrada);
                $('#modalSalida').text(salida);
                $('#modalObservaciones').text(observaciones);
                
                // Mostrar u ocultar sección de justificación
                if (estado === 'justificada') {
                    $('#modalJustificacion').show();
                } else {
                    $('#modalJustificacion').hide();
                }
                
                // Mostrar u ocultar botón de justificar
                if (estado === 'falta' && '${usuario.rol.nombre}' === 'APODERADO') {
                    $('#btnJustificar').show();
                } else {
                    $('#btnJustificar').hide();
                }
                
                $('#asistenciaModal').modal('show');
            }
            
            // Inicializar con el mes actual
            const currentDate = new Date();
            let currentYear = currentDate.getFullYear();
            let currentMonth = currentDate.getMonth();
            generateCalendar(currentYear, currentMonth);
            
            // Navegación del calendario
            $('#prevMonth').click(function() {
                currentMonth--;
                if (currentMonth < 0) {
                    currentMonth = 11;
                    currentYear--;
                }
                generateCalendar(currentYear, currentMonth);
            });
            
            $('#nextMonth').click(function() {
                currentMonth++;
                if (currentMonth > 11) {
                    currentMonth = 0;
                    currentYear++;
                }
                generateCalendar(currentYear, currentMonth);
            });
            
            // Filtros
            $('#filtroPeriodo, #filtroMes, #filtroRango').change(function() {
                // Aquí se implementaría la lógica para filtrar la asistencia
                alert('Filtrando asistencia...');
            });
            
            // Exportar a PDF
            $('#btnExportarPDF').click(function(e) {
                e.preventDefault();
                alert('Exportando asistencia a PDF...');
            });
            
            // Exportar a Excel
            $('#btnExportarExcel').click(function(e) {
                e.preventDefault();
                alert('Exportando asistencia a Excel...');
            });
            
            // Justificar falta
            $('#btnJustificar').click(function() {
                alert('Se ha enviado una solicitud de justificación. El administrador revisará su solicitud.');
                $('#asistenciaModal').modal('hide');
            });
        });
    </script>
</body>
</html>