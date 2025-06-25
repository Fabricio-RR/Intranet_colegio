<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Criterio" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Mantenimiento de Criterios - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">
<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value=" Criterios de Evaluación" scope="request" />
<c:set var="tituloPaginaMobile" value="Criterios" scope="request" />
<c:set var="iconoPagina" value="fas fa-clipboard-list" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container-fluid mt-3">

        <!-- Tabs -->
        <ul class="nav nav-tabs mb-4" id="criteriosTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="tab-catalogo" data-bs-toggle="tab" data-bs-target="#catalogo" type="button" role="tab">Catálogo de Criterios</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="tab-malla" data-bs-toggle="tab" data-bs-target="#malla" type="button" role="tab">Configuración por Curso/Periodo</button>
            </li>
        </ul>
        <div class="tab-content">
        <!-- ======================== TAB 1: Catálogo de Criterios ======================== -->
        <div class="tab-pane fade show active" id="catalogo" role="tabpanel">

            <div class="mb-3">
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalAgregarCatalogo">
                    <i class="fas fa-plus me-1"></i>Agregar Criterio
                </button>
            </div>
            <div class="card">
                <div class="card-body table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Nombre</th>
                                <th>Base</th>
                                <th>Descripción</th>
                                <th>Activo</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="c" items="${criteriosCatalogo}" varStatus="st">
                            <tr>
                                <td>${st.index + 1}</td>
                                <td>${c.nombre}</td>
                                <td>${c.base}</td>
                                <td>${c.descripcion}</td>
                                <td>
                                    <span class="badge bg-${c.activo ? 'success' : 'secondary'}">${c.activo ? 'Sí' : 'No'}</span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-outline-warning" data-bs-toggle="modal" data-bs-target="#modalEditarCatalogo"
                                        data-id="${c.idCriterio}" data-nombre="${c.nombre}" data-base="${c.base}" data-descripcion="${c.descripcion}" data-activo="${c.activo ? '1' : '0'}" title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger" onclick="desactivarCatalogo(${c.idCriterio})" title="Desactivar">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- ======================== TAB 2: Malla Criterio ======================== -->
        <div class="tab-pane fade" id="malla" role="tabpanel">

            <!-- Filtros para seleccionar malla curricular y periodo -->
            <form class="row g-3 mb-4" method="get" action="criterio">
                <div class="col-md-4">
                    <label class="form-label">Curso / Malla Curricular</label>
                    <select name="idMallaCurricular" class="form-select" required>
                        <option value="">Seleccione...</option>
                        <c:forEach var="entry" items="${mallasCurricularesAgrupadas}">
                            <optgroup label="${entry.key}">
                                <c:forEach var="malla" items="${entry.value}">
                                    <option value="${malla.idMalla}" ${malla.idMalla == idMallaCurricular ? 'selected' : ''}>
                                        ${malla.nombreCurso}
                                    </option>
                                </c:forEach>
                            </optgroup>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Periodo</label>
                    <select name="idPeriodo" class="form-select" required>
                        <option value="">Seleccione...</option>
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

            <div class="mb-3">
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalAgregarMallaCriterio">
                    <i class="fas fa-plus me-1"></i>Agregar Criterio a Malla
                </button>
            </div>
            <div class="card">
                <div class="card-body table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Criterio</th>
                                <th>Tipo</th>
                                <th>Fórmula</th>
                                <th>Base</th>
                                <th>Activo</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="mc" items="${mallaCriterios}" varStatus="st">
                            <tr>
                                <td>${st.index + 1}</td>
                                <td>${mc.criterioNombre}</td>
                                <td>${mc.tipo}</td>
                                <td>${mc.formula}</td>
                                <td>${mc.base}</td>
                                <td>
                                    <span class="badge bg-${mc.activo ? 'success' : 'secondary'}">${mc.activo ? 'Sí' : 'No'}</span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-outline-warning"
                                        data-bs-toggle="modal" data-bs-target="#modalEditarMallaCriterio"
                                        data-id="${mc.idMallaCriterio}" data-criterio="${mc.idCriterio}"
                                        data-tipo="${mc.tipo}" data-formula="${mc.formula}" data-activo="${mc.activo ? '1' : '0'}" title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger" onclick="desactivarMallaCriterio(${mc.idMallaCriterio})" title="Desactivar">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        </div>

        <!-- ============ Modals para Catálogo de Criterios ============ -->
        <div class="modal fade" id="modalAgregarCatalogo" tabindex="-1" aria-labelledby="modalAgregarCatalogoLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form class="modal-content" method="post" action="criterio">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-plus me-1"></i>Agregar Criterio</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="agregarCatalogo"/>
                        <div class="mb-3">
                            <label class="form-label">Nombre</label>
                            <input type="text" name="nombre" class="form-control" required autocomplete="off"/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Base</label>
                            <input type="number" name="base" class="form-control" min="1" max="100" step="0.01" required value="20"/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Descripción</label>
                            <input type="text" name="descripcion" class="form-control"/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Activo</label>
                            <select name="activo" class="form-select" required>
                                <option value="1" selected>Sí</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success"><i class="fas fa-save me-1"></i>Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Editar Catalogo -->
        <div class="modal fade" id="modalEditarCatalogo" tabindex="-1" aria-labelledby="modalEditarCatalogoLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form class="modal-content" method="post" action="criterio">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-edit me-1"></i>Editar Criterio</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="editarCatalogo"/>
                        <input type="hidden" id="editIdCriterio" name="idCriterio"/>
                        <div class="mb-3">
                            <label class="form-label">Nombre</label>
                            <input type="text" id="editNombre" name="nombre" class="form-control" required/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Base</label>
                            <input type="number" id="editBase" name="base" class="form-control" min="1" max="100" step="0.01" required/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Descripción</label>
                            <input type="text" id="editDescripcion" name="descripcion" class="form-control"/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Activo</label>
                            <select id="editActivo" name="activo" class="form-select" required>
                                <option value="1">Sí</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-warning"><i class="fas fa-save me-1"></i>Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- ============ Modals para Malla Criterio ============ -->
        <div class="modal fade" id="modalAgregarMallaCriterio" tabindex="-1" aria-labelledby="modalAgregarMallaCriterioLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form class="modal-content" method="post" action="criterio">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-plus me-1"></i>Agregar Criterio a Malla</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="agregarMallaCriterio"/>
                        <input type="hidden" name="idMallaCurricular" value="${idMallaCurricular}"/>
                        <input type="hidden" name="idPeriodo" value="${idPeriodo}"/>
                        <div class="mb-3">
                            <label class="form-label">Criterio</label>
                            <select name="idCriterio" class="form-select" required>
                                <option value="">Seleccione...</option>
                                <c:forEach var="c" items="${criteriosCatalogo}">
                                    <option value="${c.idCriterio}">${c.nombre} (base: ${c.base})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Tipo</label>
                            <select name="tipo" class="form-select" required>
                                <option value="editable">Editable</option>
                                <option value="promedio">Promedio</option>
                                <option value="calculado">Calculado</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Fórmula</label>
                            <input type="text" name="formula" class="form-control" autocomplete="off"/>
                            <small class="form-text text-muted">Solo si es promedio o calculado. Ej: (EP1+TP1)/2</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Activo</label>
                            <select name="activo" class="form-select" required>
                                <option value="1" selected>Sí</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success"><i class="fas fa-save me-1"></i>Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Editar Malla Criterio -->
        <div class="modal fade" id="modalEditarMallaCriterio" tabindex="-1" aria-labelledby="modalEditarMallaCriterioLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form class="modal-content" method="post" action="criterio">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-edit me-1"></i>Editar Criterio de Malla</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="editarMallaCriterio"/>
                        <input type="hidden" id="editIdMallaCriterio" name="idMallaCriterio"/>
                        <div class="mb-3">
                            <label class="form-label">Criterio</label>
                            <select id="editIdCriterio" name="idCriterio" class="form-select" required>
                                <option value="">Seleccione...</option>
                                <c:forEach var="c" items="${criteriosCatalogo}">
                                    <option value="${c.idCriterio}">${c.nombre} (base: ${c.base})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Tipo</label>
                            <select id="editTipo" name="tipo" class="form-select" required>
                                <option value="editable">Editable</option>
                                <option value="promedio">Promedio</option>
                                <option value="calculado">Calculado</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Fórmula</label>
                            <input type="text" id="editFormula" name="formula" class="form-control" autocomplete="off"/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Activo</label>
                            <select id="editActivo" name="activo" class="form-select" required>
                                <option value="1">Sí</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-warning"><i class="fas fa-save me-1"></i>Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>

    </div>

    <jsp:include page="/includes/footer.jsp" />
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script>
/* =============== Mostrar SweetAlert de éxito/error si corresponde =============== */
<%-- 
    Se apoya en parámetros success/error puestos por el Servlet: 
    ejemplo: criterio?success=1#catalogo 
--%>
<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<% if ("1".equals(success)) { %>
Swal.fire({
    icon: 'success',
    title: '¡Operación exitosa!',
    timer: 1500,
    showConfirmButton: false
});
<% } else if ("1".equals(error)) { %>
Swal.fire({
    icon: 'error',
    title: '¡Error!',
    text: 'Ocurrió un error al procesar la solicitud',
    timer: 2000,
    showConfirmButton: false
});
<% } %>

/* =============== Modal Editar Catálogo de Criterios =============== */
var modalEditarCatalogo = document.getElementById('modalEditarCatalogo');
modalEditarCatalogo?.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    document.getElementById('editIdCriterio').value = button.getAttribute('data-id');
    document.getElementById('editNombre').value = button.getAttribute('data-nombre');
    document.getElementById('editBase').value = button.getAttribute('data-base');
    document.getElementById('editDescripcion').value = button.getAttribute('data-descripcion');
    // Selecciona activo o inactivo correctamente en el select
    var activoValue = button.getAttribute('data-activo') === "true" ? "1" : "0";
    document.getElementById('editActivo').value = activoValue;
});

/* =============== Modal Editar Malla Criterio =============== */
var modalEditarMalla = document.getElementById('modalEditarMallaCriterio');
modalEditarMalla?.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    document.getElementById('editIdMallaCriterio').value = button.getAttribute('data-id');
    // Selecciona el criterio correctamente
    var criterioSelect = document.getElementById('editIdCriterio');
    var idCriterio = button.getAttribute('data-criterio');
    for (var i = 0; i < criterioSelect.options.length; i++) {
        if (criterioSelect.options[i].value === idCriterio) {
            criterioSelect.selectedIndex = i;
            break;
        }
    }
    document.getElementById('editTipo').value = button.getAttribute('data-tipo');
    document.getElementById('editFormula').value = button.getAttribute('data-formula');
    // Selecciona activo o inactivo correctamente en el select
    var activoValue = button.getAttribute('data-activo') === "true" ? "1" : "0";
    document.getElementById('editActivo').value = activoValue;
});

/* =============== Desactivar Catálogo (Soft Delete) =============== */
function desactivarCatalogo(id) {
    Swal.fire({
        icon: 'warning',
        title: '¿Está seguro?',
        text: 'Esta acción desactivará el criterio. Podrá volver a activarlo luego si lo desea.',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Sí, desactivar'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location = 'criterio?action=desactivarCatalogo&idCriterio=' + id;
        }
    });
}

/* =============== Desactivar Malla Criterio (Soft Delete) =============== */
function desactivarMallaCriterio(id) {
    // Recupera los filtros para mantener la vista después de la acción
    var idMalla = "${idMallaCurricular}";
    var idPeriodo = "${idPeriodo}";
    Swal.fire({
        icon: 'warning',
        title: '¿Está seguro?',
        text: 'Esta acción desactivará el criterio de la malla. Podrá volver a activarlo luego si lo desea.',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Sí, desactivar'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location = 'criterio?action=desactivarMallaCriterio&idMallaCriterio=' + id
                + '&idMallaCurricular=' + idMalla + '&idPeriodo=' + idPeriodo;
        }
    });
}
</script>

</body>
</html>
