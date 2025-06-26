<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comunicados - Colegio Peruano Chino Diez de Octubre</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/dashboard.css">
    <style>
        .comunicado-card {
            transition: transform 0.3s;
            border-left: 4px solid #0A0A3D;
            margin-bottom: 1.5rem;
        }
        .comunicado-card:hover {
            transform: translateY(-5px);
        }
        .comunicado-fecha {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .comunicado-titulo {
            color: #0A0A3D;
            font-weight: bold;
        }
        .comunicado-emisor {
            font-size: 0.85rem;
            color: #495057;
        }
        .comunicado-alcance {
            font-size: 0.8rem;
            background-color: #e9ecef;
            padding: 2px 8px;
            border-radius: 10px;
        }
        .comunicado-content {
            max-height: 100px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        .filter-section {
            background-color: #f8f9fa;  
            border-radius: 0.5rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
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
                    <h1 class="h2">Comunicados</h1>
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
                
                <!-- Filtros de comunicados -->
                <div class="filter-section">
                    <form action="comunicados" method="get" class="row g-3">
                        <div class="col-md-4">
                            <label for="filtroFecha" class="form-label">Fecha</label>
                            <select class="form-select" id="filtroFecha" name="filtroFecha">
                                <option value="">Todas las fechas</option>
                                <option value="hoy">Hoy</option>
                                <option value="semana">Esta semana</option>
                                <option value="mes">Este mes</option>
                                <option value="bimestre">Este bimestre</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="filtroAlcance" class="form-label">Alcance</label>
                            <select class="form-select" id="filtroAlcance" name="filtroAlcance">
                                <option value="">Todos los alcances</option>
                                <option value="general">General</option>
                                <option value="primaria">Primaria</option>
                                <option value="secundaria">Secundaria</option>
                                <option value="curso">Por curso</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="filtroBusqueda" class="form-label">Búsqueda</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="filtroBusqueda" name="filtroBusqueda" placeholder="Buscar...">
                                <button class="btn btn-outline-secondary" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
                
                <!-- Lista de comunicados -->
                <div class="row">
                    <c:choose>
                        <c:when test="${empty comunicados}">
                            <div class="col-12">
                                <div class="alert alert-info" role="alert">
                                    <i class="bi bi-info-circle me-2"></i> No hay comunicados disponibles con los filtros seleccionados.
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="comunicado" items="${comunicados}">
                                <div class="col-md-6">
                                    <div class="card border-0 shadow-sm comunicado-card">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <span class="comunicado-fecha">
                                                    <i class="bi bi-calendar3"></i> 
                                                    <fmt:formatDate value="${comunicado.fechaEmision}" pattern="dd/MM/yyyy HH:mm" />
                                                </span>
                                                <span class="comunicado-alcance">
                                                    ${comunicado.alcance}
                                                </span>
                                            </div>
                                            <h5 class="comunicado-titulo">${comunicado.titulo}</h5>
                                            <div class="comunicado-content mb-3">
                                                ${comunicado.contenido}
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <span class="comunicado-emisor">
                                                    <i class="bi bi-person"></i> ${comunicado.nombreEmisor}
                                                </span>
                                                <a href="#" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#comunicadoModal${comunicado.idComunicado}">
                                                    Leer más
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Modal para ver comunicado completo -->
                                    <div class="modal fade" id="comunicadoModal${comunicado.idComunicado}" tabindex="-1" aria-labelledby="comunicadoModalLabel${comunicado.idComunicado}" aria-hidden="true">
                                        <div class="modal-dialog modal-lg">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="comunicadoModalLabel${comunicado.idComunicado}">${comunicado.titulo}</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <span class="comunicado-fecha">
                                                            <i class="bi bi-calendar3"></i> 
                                                            <fmt:formatDate value="${comunicado.fechaEmision}" pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                        <span class="comunicado-alcance">
                                                            ${comunicado.alcance}
                                                        </span>
                                                    </div>
                                                    <div class="comunicado-content-full">
                                                        ${comunicado.contenido}
                                                    </div>
                                                    <hr>
                                                    <p class="comunicado-emisor mb-0">
                                                        <i class="bi bi-person"></i> ${comunicado.nombreEmisor}
                                                    </p>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                                                    <button type="button" class="btn btn-primary" onclick="imprimirComunicado(${comunicado.idComunicado})">
                                                        <i class="bi bi-printer"></i> Imprimir
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <!-- Paginación -->
                            <div class="col-12">
                                <nav aria-label="Paginación de comunicados">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${paginaActual == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="comunicados?pagina=${paginaActual - 1}" aria-label="Anterior">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPaginas}" var="i">
                                            <li class="page-item ${paginaActual == i ? 'active' : ''}">
                                                <a class="page-link" href="comunicados?pagina=${i}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${paginaActual == totalPaginas ? 'disabled' : ''}">
                                            <a class="page-link" href="comunicados?pagina=${paginaActual + 1}" aria-label="Siguiente">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Función para imprimir un comunicado específico
        function imprimirComunicado(idComunicado) {
            const modalContent = document.querySelector(`#comunicadoModal${idComunicado} .modal-content`).cloneNode(true);
            const printWindow = window.open('', '_blank');
            
            printWindow.document.write(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Comunicado - Colegio Peruano Chino Diez de Octubre</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                    <style>
                        body { padding: 20px; }
                        .modal-header { border-bottom: 1px solid #dee2e6; padding-bottom: 10px; margin-bottom: 20px; }
                        .modal-footer { display: none; }
                        .comunicado-fecha { font-size: 0.85rem; color: #6c757d; }
                        .comunicado-alcance { font-size: 0.8rem; background-color: #e9ecef; padding: 2px 8px; border-radius: 10px; }
                        .comunicado-emisor { font-size: 0.85rem; color: #495057; }
                        @media print {
                            .modal-header { border-bottom: 1px solid #000; }
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="row">
                            <div class="col-12">
                                <div class="text-center mb-4">
                                    <img src="assets/img/EscudoCDO.png" alt="Escudo CDO" style="height: 80px;">
                                    <h3>Colegio Peruano Chino Diez de Octubre</h3>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                ${modalContent.outerHTML}
                            </div>
                        </div>
                    </div>
                </body>
                </html>
            `);
            
            printWindow.document.close();
            printWindow.focus();
            
            // Esperar a que los estilos se carguen
            setTimeout(() => {
                printWindow.print();
                printWindow.close();
            }, 1000);
        }
        
        // Función para exportar comunicados a CSV
        document.getElementById('btnExportar').addEventListener('click', function() {
            // Implementar la exportación a CSV
            alert('Funcionalidad de exportación en desarrollo');
        });
    </script>
</body>
</html>
