<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes Académicos - Colegio Peruano Chino Diez de Octubre</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/dashboard.css">
    <style>
        .report-card {
            transition: transform 0.3s;
            border-left: 4px solid #0A0A3D;
            margin-bottom: 1.5rem;
        }
        .report-card:hover {
            transform: translateY(-5px);
        }
        .report-icon {
            font-size: 2.5rem;
            color: #0A0A3D;
            margin-bottom: 1rem;
        }
        .report-title {
            color: #0A0A3D;
            font-weight: bold;
        }
        .report-description {
            color: #6c757d;
            margin-bottom: 1rem;
        }
        .filter-section {
            background-color: #f8f9fa;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .tab-content {
            padding-top: 1.5rem;
        }
        .chart-container {
            height: 400px;
            margin-bottom: 2rem;
        }
        .table-container {
            margin-bottom: 2rem;
        }
        .nota-aprobado {
            background-color: #d4edda;
            color: #155724;
        }
        .nota-regular {
            background-color: #fff3cd;
            color: #856404;
        }
        .nota-desaprobado {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            
            
            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Reportes Académicos</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="window.print()">
                                <i class="bi bi-printer"></i> Imprimir
                            </button>
                            
                        </div>
                    </div>
                </div>
                
                <!-- Tipos de reportes -->
                <div class="row mb-4">
                    <div class="col-md-4 mb-4">
                        <div class="card border-0 shadow-sm report-card">
                            <div class="card-body text-center">
                                <div class="report-icon">
                                    <i class="bi bi-journal-check"></i>
                                </div>
                                <h5 class="report-title">Consolidado de Notas</h5>
                                <p class="report-description">Reporte consolidado de notas por curso, grado o alumno.</p>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#consolidadoNotasModal">
                                    Generar Reporte
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-4">
                        <div class="card border-0 shadow-sm report-card">
                            <div class="card-body text-center">
                                <div class="report-icon">
                                    <i class="bi bi-bar-chart"></i>
                                </div>
                                <h5 class="report-title">Rendimiento Académico</h5>
                                <p class="report-description">Análisis estadístico del rendimiento académico por curso o grado.</p>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#rendimientoModal">
                                    Generar Reporte
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-4">
                        <div class="card border-0 shadow-sm report-card">
                            <div class="card-body text-center">
                                <div class="report-icon">
                                    <i class="bi bi-calendar-check"></i>
                                </div>
                                <h5 class="report-title">Asistencia</h5>
                                <p class="report-description">Reporte de asistencia por alumno, curso o grado.</p>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#asistenciaModal">
                                    Generar Reporte
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-4">
                        <div class="card border-0 shadow-sm report-card">
                            <div class="card-body text-center">
                                <div class="report-icon">
                                    <i class="bi bi-file-earmark-text"></i>
                                </div>
                                <h5 class="report-title">Exámenes y Evaluaciones</h5>
                                <p class="report-description">Reporte de resultados de exámenes y evaluaciones.</p>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#examenesModal">
                                    Generar Reporte
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-4">
                        <div class="card border-0 shadow-sm report-card">
                            <div class="card-body text-center">
                                <div class="report-icon">
                                    <i class="bi bi-person-lines-fill"></i>
                                </div>
                                <h5 class="report-title">Libreta de Notas</h5>
                                <p class="report-description">Generación de libretas de notas para entrega a padres.</p>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#libretaModal">
                                    Generar Reporte
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-4">
                        <div class="card border-0 shadow-sm report-card">
                            <div class="card-body text-center">
                                <div class="report-icon">
                                    <i class="bi bi-graph-up"></i>
                                </div>
                                <h5 class="report-title">Progreso del Alumno</h5>
                                <p class="report-description">Análisis de progreso individual de alumnos a lo largo del tiempo.</p>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#progresoModal">
                                    Generar Reporte
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Reportes recientes -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Reportes Recientes</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Fecha</th>
                                        <th>Tipo de Reporte</th>
                                        <th>Generado por</th>
                                        <th>Descripción</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>12/05/2023 14:30</td>
                                        <td>Consolidado de Notas</td>
                                        <td>Prof. Juan Pérez</td>
                                        <td>Consolidado de notas - Matemáticas 3° Secundaria - Primer Bimestre</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye"></i> Ver
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary me-1">
                                                <i class="bi bi-download"></i> Descargar
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>10/05/2023 09:15</td>
                                        <td>Rendimiento Académico</td>
                                        <td>Coordinación Académica</td>
                                        <td>Análisis de rendimiento - 3° Secundaria - Primer Bimestre</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye"></i> Ver
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary me-1">
                                                <i class="bi bi-download"></i> Descargar
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>08/05/2023 16:45</td>
                                        <td>Asistencia</td>
                                        <td>Prof. María Rodríguez</td>
                                        <td>Reporte de asistencia - Comunicación 3° Secundaria - Mayo 2023</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye"></i> Ver
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary me-1">
                                                <i class="bi bi-download"></i> Descargar
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>05/05/2023 11:20</td>
                                        <td>Libreta de Notas</td>
                                        <td>Coordinación Académica</td>
                                        <td>Libretas de notas - 3° Secundaria - Primer Bimestre</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye"></i> Ver
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary me-1">
                                                <i class="bi bi-download"></i> Descargar
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>03/05/2023 10:00</td>
                                        <td>Exámenes y Evaluaciones</td>
                                        <td>Prof. Carlos Sánchez</td>
                                        <td>Resultados de examen parcial - Ciencias 3° Secundaria</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye"></i> Ver
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary me-1">
                                                <i class="bi bi-download"></i> Descargar
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Modal para Consolidado de Notas -->
    <div class="modal fade" id="consolidadoNotasModal" tabindex="-1" aria-labelledby="consolidadoNotasModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="consolidadoNotasModalLabel">Consolidado de Notas</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="filter-section mb-4">
                        <form id="formConsolidadoNotas" class="row g-3">
                            <div class="col-md-4">
                                <label for="periodoConsolidado" class="form-label">Periodo</label>
                                <select class="form-select" id="periodoConsolidado" required>
                                    <option value="">Seleccione un periodo</option>
                                    <option value="1" selected>Primer Bimestre</option>
                                    <option value="2">Segundo Bimestre</option>
                                    <option value="3">Tercer Bimestre</option>
                                    <option value="4">Cuarto Bimestre</option>
                                    <option value="anual">Anual</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="gradoConsolidado" class="form-label">Grado</label>
                                <select class="form-select" id="gradoConsolidado" required>
                                    <option value="">Seleccione un grado</option>
                                    <option value="1">1° Secundaria</option>
                                    <option value="2">2° Secundaria</option>
                                    <option value="3" selected>3° Secundaria</option>
                                    <option value="4">4° Secundaria</option>
                                    <option value="5">5° Secundaria</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="cursoConsolidado" class="form-label">Curso</label>
                                <select class="form-select" id="cursoConsolidado">
                                    <option value="">Todos los cursos</option>
                                    <option value="1" selected>Matemáticas</option>
                                    <option value="2">Comunicación</option>
                                    <option value="3">Ciencias</option>
                                    <option value="4">Historia</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="tipoConsolidado" class="form-label">Tipo de Reporte</label>
                                <select class="form-select" id="tipoConsolidado" required>
                                    <option value="detallado" selected>Detallado (todas las evaluaciones)</option>
                                    <option value="resumido">Resumido (solo promedios)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="formatoConsolidado" class="form-label">Formato</label>
                                <select class="form-select" id="formatoConsolidado" required>
                                    <option value="pdf" selected>PDF</option>
                                    <option value="excel">Excel</option>
                                    <option value="html">HTML</option>
                                </select>
                            </div>
                            <div class="col-12 text-center mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-file-earmark-text"></i> Generar Reporte
                                </button>
                            </div>
                        </form>
                    </div>
                    
                    <!-- Vista previa del reporte -->
                    <div class="report-preview">
                        <h4 class="text-center mb-3">Vista Previa</h4>
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th rowspan="2" style="vertical-align: middle;">N°</th>
                                        <th rowspan="2" style="vertical-align: middle;">Alumno</th>
                                        <th colspan="4" class="text-center">Evaluaciones</th>
                                        <th rowspan="2" style="vertical-align: middle;">Promedio</th>
                                    </tr>
               
