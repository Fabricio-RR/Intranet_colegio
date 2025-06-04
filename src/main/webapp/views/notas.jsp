<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notas - Colegio Peruano Chino Diez de Octubre</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/dashboard.css">
    <style>
        .custom-header {
            background-color: #0A0A3D;
            color: white;
        }
        .nota-table th {
            background-color: #0A0A3D;
            color: white;
            text-align: center;
        }
        .nota-valor {
            font-weight: bold;
            text-align: center;
            width: 60px;
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
        .curso-header {
            background-color: #e9ecef;
            font-weight: bold;
            color: #0A0A3D;
        }
        .periodo-header {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .promedio-row {
            font-weight: bold;
            background-color: #f8f9fa;
        }
        .sin-notas {
            padding: 40px;
            text-align: center;
            color: #6c757d;
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
                    <h1 class="h2">Notas Académicas</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="window.print()">
                                <i class="bi bi-printer"></i> Imprimir
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-secondary" id="btnExportar">
                                <i class="bi bi-download"></i> Exportar
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Contenido de notas -->
                <c:choose>
                    <c:when test="${empty notasPorCursoYPeriodo}">
                        <div class="card border-0 shadow-sm mb-4">
                            <div class="card-body sin-notas">
                                <i class="bi bi-journal-x" style="font-size: 3rem;"></i>
                                <h4 class="mt-3">No hay notas registradas</h4>
                                <p>Actualmente no hay notas registradas para mostrar.</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="cursoEntry" items="${notasPorCursoYPeriodo}">
                            <div class="card border-0 shadow-sm mb-4">
                                <div class="card-header curso-header">
                                    ${cursoEntry.key}
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered nota-table">
                                            <c:forEach var="periodoEntry" items="${cursoEntry.value}">
                                                <thead>
                                                    <tr>
                                                        <th colspan="4" class="periodo-header">${periodoEntry.key}</th>
                                                    </tr>
                                                    <tr>
                                                        <th width="40%">Evaluación</th>
                                                        <th width="20%">Fecha</th>
                                                        <th width="10%">Nota</th>
                                                        <th width="30%">Observación</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:set var="sumaNotas" value="0" />
                                                    <c:set var="cantidadNotas" value="0" />
                                                    
                                                    <c:forEach var="nota" items="${periodoEntry.value}">
                                                        <tr>
                                                            <td>${nota.tipoEvaluacion}</td>
                                                            <td class="text-center">
                                                                <fmt:formatDate value="${nota.fechaRegistro}" pattern="dd/MM/yyyy" />
                                                            </td>
                                                            <td class="nota-valor ${nota.valor >= 14 ? 'nota-aprobado' : (nota.valor >= 11 ? 'nota-regular' : 'nota-desaprobado')}">
                                                                ${nota.valor}
                                                            </td>
                                                            <td>${nota.observacion}</td>
                                                        </tr>
                                                        
                                                        <c:set var="sumaNotas" value="${sumaNotas + nota.valor}" />
                                                        <c:set var="cantidadNotas" value="${cantidadNotas + 1}" />
                                                    </c:forEach>
                                                    
                                                    <c:if test="${cantidadNotas > 0}">
                                                        <c:set var="promedio" value="${sumaNotas / cantidadNotas}" />
                                                        <tr class="promedio-row">
                                                            <td colspan="2" class="text-end">Promedio:</td>
                                                            <td class="nota-valor ${promedio >= 14 ? 'nota-aprobado' : (promedio >= 11 ? 'nota-regular' : 'nota-desaprobado')}">
                                                                <fmt:formatNumber value="${promedio}" pattern="#.##" />
                                                            </td>
                                                            <td></td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </c:forEach>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para exportar las notas a CSV
        document.getElementById('btnExportar').addEventListener('click', function() {
            let csv = 'Curso,Periodo,Evaluación,Fecha,Nota,Observación\n';
            
            const tablas = document.querySelectorAll('.nota-table');
            
            tablas.forEach(tabla => {
                const curso = tabla.closest('.card').querySelector('.curso-header').textContent.trim();
                let periodo = '';
                
                const filas = tabla.querySelectorAll('tr');
                
                filas.forEach(fila => {
                    const celdas = fila.querySelectorAll('th, td');
                    
                    // Si es un encabezado de periodo
                    if (celdas.length === 1 && celdas[0].classList.contains('periodo-header')) {
                        periodo = celdas[0].textContent.trim();
                    }
                    
                    // Si es una fila de datos (no encabezado ni promedio)
                    if (celdas.length === 4 && !fila.classList.contains('promedio-row') && !celdas[0].tagName.toLowerCase().includes('th')) {
                        const evaluacion = celdas[0].textContent.trim();
                        const fecha = celdas[1].textContent.trim();
                        const nota = celdas[2].textContent.trim();
                        const observacion = celdas[3].textContent.trim();
                        
                        // Escapar comillas y añadir comillas alrededor del texto
                        const cursoEsc = '"' + curso.replace(/"/g, '""') + '"';
                        const periodoEsc = '"' + periodo.replace(/"/g, '""') + '"';
                        const evaluacionEsc = '"' + evaluacion.replace(/"/g, '""') + '"';
                        const fechaEsc = '"' + fecha.replace(/"/g, '""') + '"';
                        const notaEsc = '"' + nota.replace(/"/g, '""') + '"';
                        const observacionEsc = '"' + observacion.replace(/"/g, '""') + '"';
                        
                        csv += `${cursoEsc},${periodoEsc},${evaluacionEsc},${fechaEsc},${notaEsc},${observacionEsc}\n`;
                    }
                });
            });
            
            // Crear un enlace para descargar el archivo CSV
            const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.setAttribute('href', url);
            link.setAttribute('download', 'notas_academicas.csv');
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
    </script>
</body>
</html>
