<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Notas" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Mantenimiento de Criterios - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Mantenimiento de Criterios de Evaluación" scope="request" />
<c:set var="tituloPaginaMobile" value="Criterios" scope="request" />
<c:set var="iconoPagina" value="fas fa-clipboard-list" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container-fluid mt-3">
        <!-- Filtros -->
        <form class="row g-3 mb-4" method="get" action="">
            <div class="col-md-4">
                <label class="form-label">Curso</label>
                <select name="idCurso" class="form-select" required>
                    <option value="">Seleccione un curso</option>
                    <c:forEach var="curso" items="${cursos}">
                        <option value="${curso.idCurso}" ${curso.idCurso == idCurso ? 'selected' : ''}>${curso.nombre}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label">Periodo</label>
                <select name="idPeriodo" class="form-select" required>
                    <option value="">Seleccione un periodo</option>
                    <c:forEach var="periodo" items="${periodos}">
                        <option value="${periodo.idPeriodo}" ${periodo.idPeriodo == idPeriodo ? 'selected' : ''}>${periodo.nombre}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-outline-primary btn-uniform">
                    <i class="fas fa-search me-1"></i>Buscar
                </button>
            </div>
        </form>

        <!-- Tabla de criterios -->
        <c:if test="${not empty criterios}">
            <div class="card">
                <div class="card-body table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Nombre</th>
                                <th>Tipo</th>
                                <th>Peso (%)</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${criterios}" varStatus="st">
                                <tr>
                                    <td>${st.index + 1}</td>
                                    <td>${c.nombre}</td>
                                    <td>${c.tipo}</td>
                                    <td>${c.peso}</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-warning" data-bs-toggle="modal" data-bs-target="#modalEditar"
                                            data-id="${c.idCriterio}" data-nombre="${c.nombre}" data-tipo="${c.tipo}" data-peso="${c.peso}" title="Editar">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" onclick="eliminarCriterio(${c.idCriterio})" title="Eliminar">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- Botón agregar -->
        <button class="btn btn-success mt-4" data-bs-toggle="modal" data-bs-target="#modalAgregar">
            <i class="fas fa-plus me-1"></i>Agregar Criterio
        </button>
    </div>

    <!-- Modal Agregar -->
    <div class="modal fade" id="modalAgregar" tabindex="-1" aria-labelledby="modalAgregarLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form class="modal-content" method="post" action="criterios">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalAgregarLabel"><i class="fas fa-plus me-1"></i>Agregar Criterio</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="agregar"/>
                    <input type="hidden" name="idCurso" value="${idCurso}"/>
                    <input type="hidden" name="idPeriodo" value="${idPeriodo}"/>
                    <div class="mb-3">
                        <label class="form-label">Nombre</label>
                        <input type="text" name="nombre" class="form-control" required autocomplete="off"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tipo</label>
                        <input type="text" name="tipo" class="form-control" required autocomplete="off"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Peso (%)</label>
                        <input type="number" name="peso" class="form-control" min="1" max="100" step="0.1" required/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success"><i class="fas fa-save me-1"></i>Guardar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Editar -->
    <div class="modal fade" id="modalEditar" tabindex="-1" aria-labelledby="modalEditarLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form class="modal-content" method="post" action="criterios">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalEditarLabel"><i class="fas fa-edit me-1"></i>Editar Criterio</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="editar"/>
                    <input type="hidden" id="editIdCriterio" name="idCriterio"/>
                    <div class="mb-3">
                        <label class="form-label">Nombre</label>
                        <input type="text" id="editNombre" name="nombre" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tipo</label>
                        <input type="text" id="editTipo" name="tipo" class="form-control" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Peso (%)</label>
                        <input type="number" id="editPeso" name="peso" class="form-control" min="1" max="100" step="0.1" required/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-warning"><i class="fas fa-save me-1"></i>Guardar Cambios</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    var modalEditar = document.getElementById('modalEditar');
    modalEditar.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        document.getElementById('editIdCriterio').value = button.getAttribute('data-id');
        document.getElementById('editNombre').value = button.getAttribute('data-nombre');
        document.getElementById('editTipo').value = button.getAttribute('data-tipo');
        document.getElementById('editPeso').value = button.getAttribute('data-peso');
    });

    function eliminarCriterio(id) {
        Swal.fire({
            icon: 'warning',
            title: '¿Está seguro?',
            text: 'Esta acción eliminará el criterio.',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, eliminar'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location = 'criterios?action=eliminar&idCriterio=' + id + '&idCurso=${idCurso}&idPeriodo=${idPeriodo}';
            }
        });
    }
</script>
</body>
</html>
