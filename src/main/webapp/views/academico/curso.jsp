<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Cursos" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Gestión de Cursos - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Gestión de Cursos" scope="request" />
<c:set var="tituloPaginaMobile" value="Cursos" scope="request" />
<c:set var="iconoPagina" value="fas fa-book" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <!-- Encabezado -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-end gap-2">
                    <button type="button"
                            class="btn btn-admin-primary btn-sm btn-uniform"
                            data-bs-toggle="modal"
                            data-bs-target="#modalCrearCurso">
                        <i class="fas fa-plus me-1"></i>
                        <span class="d-none d-sm-inline">Nuevo</span> Curso
                    </button>
                </div>
            </div>
        </div>
    </div>
    <!-- Tabla de cursos -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body table-responsive">
                    <table id="tablaCursos" class="table table-hover align-middle nowrap">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Nombre</th>
                                <th>Área</th>
                                <th>Orden</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${cursos}" varStatus="s">
                                <tr>
                                    <td>${s.index + 1}</td>
                                    <td>${fn:escapeXml(c.nombreCurso)}</td>
                                    <td>${fn:escapeXml(c.area)}</td>
                                    <td>${c.orden}</td>
                                    <td>
                                        <span class="badge ${c.activo ? 'bg-success' : 'bg-danger'}">
                                            ${c.activo ? 'Activo' : 'Inactivo'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-warning btn-editar"
                                                    data-id="${c.idCurso}"
                                                    data-nombre="${fn:escapeXml(c.nombreCurso)}"
                                                    data-area="${fn:escapeXml(c.area)}"
                                                    data-orden="${c.orden}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger btn-desactivar"
                                                    data-id="${c.idCurso}" ${!c.activo ? 'disabled' : ''}>
                                                <i class="fas fa-ban"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal: Crear Curso -->
    <div class="modal fade" id="modalCrearCurso" tabindex="-1" aria-labelledby="modalCrearCursoLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form id="formCrearCurso" action="${pageContext.request.contextPath}/cursos" method="post" class="modal-content">
                <input type="hidden" name="action" value="crear" />
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-plus"></i> Nuevo Curso</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="nombreCrear" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="nombreCrear" name="nombre" required maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label for="areaCrear" class="form-label">Área</label>
                        <input type="text" class="form-control" id="areaCrear" name="area" required maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label for="ordenCrear" class="form-label">Orden</label>
                        <input type="number" class="form-control" id="ordenCrear" name="orden" min="1" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-danger btn-sm btn-uniform" data-bs-dismiss="modal"><i class="fas fa-times me-1"></i>Cancelar</button>
                    <button type="submit" class="btn btn-admin-primary btn-uniform"><i class="fas fa-save me-1"></i> Guardar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal: Editar Curso -->
    <div class="modal fade" id="modalEditarCurso" tabindex="-1">
        <div class="modal-dialog">
            <form id="formEditarCurso" action="${pageContext.request.contextPath}/cursos" method="post" class="modal-content">
                <input type="hidden" name="action" value="editar" />
                <input type="hidden" name="idCurso" id="idCursoEditar">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit"></i> Editar Curso</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="nombreEditar" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="nombreEditar" name="nombre" required maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label for="areaEditar" class="form-label">Área</label>
                        <input type="text" class="form-control" id="areaEditar" name="area" required maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label for="ordenEditar" class="form-label">Orden</label>
                        <input type="number" class="form-control" id="ordenEditar" name="orden" min="1" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-uniform" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-admin-primary btn-uniform">Actualizar</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />
</main>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script>
    $(document).ready(function () {
        // DataTable
        $('#tablaCursos').DataTable({
            ordering: false,
            language: {
                url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
            },
            pageLength: 25,
            lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
            lengthChange: true,
            responsive: true
        });

        // Modal Editar Curso
        $('.btn-editar').click(function () {
            const btn = $(this);
            $('#idCursoEditar').val(btn.data('id'));
            $('#nombreEditar').val(btn.data('nombre'));
            $('#areaEditar').val(btn.data('area'));
            $('#ordenEditar').val(btn.data('orden'));
            $('#modalEditarCurso').modal('show');
        });

        // Desactivar curso
        $('.btn-desactivar').click(function () {
            const id = $(this).data('id');
            Swal.fire({
                title: '¿Desactivar curso?',
                text: "El curso no podrá ser asignado en la malla curricular.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, desactivar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/cursos?action=desactivar&id=' + id;
                }
            });
        });

        // Mensajes de éxito y error (SweetAlert2 personalizado)
        <c:if test="${not empty param.success}">
            <c:choose>
                <c:when test="${param.success == '1' && param.op == 'add'}">
                    Swal.fire({
                        icon: 'success',
                        title: 'Curso registrado',
                        text: 'El curso fue creado correctamente.',
                        timer: 2200,
                        showConfirmButton: false
                    });
                </c:when>
                <c:when test="${param.success == '1' && param.op == 'edit'}">
                    Swal.fire({
                        icon: 'success',
                        title: 'Curso actualizado',
                        text: 'Los cambios fueron guardados correctamente.',
                        timer: 2200,
                        showConfirmButton: false
                    });
                </c:when>
                <c:when test="${param.success == '1' && param.op == 'deactivate'}">
                    Swal.fire({
                        icon: 'info',
                        title: 'Curso desactivado',
                        text: 'El curso fue desactivado exitosamente.',
                        timer: 2200,
                        showConfirmButton: false
                    });
                </c:when>
                <c:otherwise>
                    Swal.fire({
                        icon: 'success',
                        title: 'Operación exitosa',
                        timer: 2200,
                        showConfirmButton: false
                    });
                </c:otherwise>
            </c:choose>
        </c:if>

        <c:if test="${not empty param.error}">
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: '${param.error}',
                timer: 3000,
                showConfirmButton: false
            });
        </c:if>
    });
</script>
</body>
</html>
