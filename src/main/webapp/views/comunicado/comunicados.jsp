<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Comunicado" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Gestión de Comunicados - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Gestión de Comunicados" scope="request" />
<c:set var="tituloPaginaMobile" value="Comunicados" scope="request" />
<c:set var="iconoPagina" value="fas fa-bullhorn" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">

    <!-- Encabezado -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/comunicado?action=crear"
                       class="btn btn-admin-primary btn-sm btn-uniform">
                        <i class="fas fa-plus me-1"></i><span class="d-none d-sm-inline">Nuevo</span> Comunicado
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Tabla de comunicados -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body table-responsive">
                    <table id="tablaComunicados" class="table table-hover align-middle nowrap">
                        <thead class="table-light">
                            <tr>
                                <th>Título</th>
                                <th>Tipo</th>
                                <th>Público</th>
                                <th>Inicio</th>
                                <th>Fin</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${comunicados}">
                                <tr>
                                    <td>${fn:escapeXml(c.titulo)}</td>
                                    <td><span class="badge bg-info text-dark text-uppercase">${c.categoria}</span></td>
                                    <td class="text-capitalize">${c.destinatario}</td>
                                    <td><fmt:formatDate value="${c.fecInicio}" pattern="dd/MM/yyyy" /></td>
                                    <td><fmt:formatDate value="${c.fecFin}" pattern="dd/MM/yyyy" /></td>
                                    <td>
                                        <span class="badge
                                            ${c.estado == 'programada' ? 'bg-primary' :
                                              c.estado == 'activa' ? 'bg-success' :
                                              c.estado == 'expirada' ? 'bg-warning text-dark' :
                                              c.estado == 'archivada' ? 'bg-secondary' : 'bg-light'} text-uppercase">
                                            ${c.estado}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-primary btn-ver" data-id="${c.id}" title="Ver comunicado">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-warning btn-editar" data-id="${c.id}" title="Editar comunicado">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger btn-desactivar" data-id="${c.id}" title="Desactivar comunicado">
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

    <!-- Modal: Editar Comunicado -->
    <div class="modal fade" id="modalEditarComunicado" tabindex="-1">
      <div class="modal-dialog  modal-dialog-scrollable modal-fullscreen-sm-down modal-lg">
        <div class="modal-content" id="contenidoModalEditar">
          <!-- Aquí se carga editar.jsp vía AJAX -->
        </div>
      </div>
    </div>

    <!-- Modal: Ver Comunicado -->
    <div class="modal fade" id="modalVerComunicado" tabindex="-1" aria-labelledby="modalVerLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content" id="contenidoModalVer"></div>
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
        $('#tablaComunicados').DataTable({
            language: {
                url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
            },
            pageLength: 25,
            lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
            lengthChange: true,
            responsive: true
        });

        // Botón ver
        $('.btn-ver').click(function () {
            const id = $(this).data('id');
            $('#contenidoModalVer').html('<div class="text-center p-4"><div class="spinner-border" role="status"></div></div>');
            $('#modalVerComunicado').modal('show');
            $.get('${pageContext.request.contextPath}/comunicado?action=ver&id=' + id, function (data) {
                $('#contenidoModalVer').html(data);
            });
        });

        // Botón editar
        $('.btn-editar').click(function () {
            const id = $(this).data('id');
            $('#contenidoModalEditar').html('<div class="text-center p-4"><div class="spinner-border" role="status"></div></div>');
            $('#modalEditarComunicado').modal('show');
            $.get('${pageContext.request.contextPath}/comunicado?action=editar&id=' + id, function (data) {
                $('#contenidoModalEditar').html(data);
            });
        });

        // Botón desactivar
        $('.btn-desactivar').click(function () {
            const id = $(this).data('id');
            Swal.fire({
                title: '¿Desactivar comunicado?',
                text: "El comunicado ya no estará disponible públicamente.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, desactivar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/comunicado?action=desactivar&id=' + id;
                }
            });
        });

        // Validación de archivo
        $('#formCrearComunicado, #formEditarComunicado').on('submit', function (e) {
            const input = $(this).find('input[type="file"]')[0];
            const archivo = input.files[0];
            if (archivo) {
                const tipo = archivo.type;
                const permitido = ['application/pdf', 'image/jpeg', 'image/png'];
                if (!permitido.includes(tipo)) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'error',
                        title: 'Archivo no válido',
                        text: 'Solo se permiten archivos JPG, PNG o PDF.'
                    });
                    return;
                }
                if (archivo.size > 5 * 1024 * 1024) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'error',
                        title: 'Archivo muy grande',
                        text: 'El archivo no debe superar los 5MB.'
                    });
                }
            }
        });

        // ÉXITO
        <c:if test="${not empty param.success}">
            <c:choose>
                <c:when test="${param.success == '1' && param.op == 'add'}">
                    Swal.fire({
                        icon: 'success',
                        title: 'Comunicado registrado',
                        text: 'El comunicado fue creado correctamente.',
                        timer: 2500,
                        showConfirmButton: false
                    });
                </c:when>
                <c:when test="${param.success == '1' && param.op == 'edit'}">
                    Swal.fire({
                        icon: 'success',
                        title: 'Comunicado actualizado',
                        text: 'Los cambios fueron guardados correctamente.',
                        timer: 2500,
                        showConfirmButton: false
                    });
                </c:when>
                <c:when test="${param.success == '1' && param.op == 'deactivate'}">
                    Swal.fire({
                        icon: 'info',
                        title: 'Comunicado desactivado',
                        text: 'El comunicado fue desactivado exitosamente.',
                        timer: 2500,
                        showConfirmButton: false
                    });
                </c:when>
            </c:choose>
        </c:if>

        // ERROR
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
