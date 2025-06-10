<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Ver Malla Curricular - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        @media (max-width: 768px) {
        .dataTables_wrapper .dataTables_scroll {
          overflow-x: auto;
        }

        .table.dataTable {
          width: 100% !important;
          display: block;
        }
      }
 </style>
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">
<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Malla Curricular" scope="request" />
<c:set var="tituloPaginaMobile" value="Malla" scope="request" />
<c:set var="iconoPagina" value="fas fa-layer-group" scope="request" />
<jsp:include page="/includes/header.jsp" />
<main class="main-content">

    <div class="card mb-4">
        <div class="card-header d-flex flex-wrap justify-content-end align-items-center gap-2">
            
            <a href="${pageContext.request.contextPath}/malla?action=gestionar" class="btn btn-admin-primary btn-sm">
                <i class="fas fa-plus me-1"></i> Gestionar Malla
            </a>
        </div>
        <div class="card-body">
            <form id="filtroMallaForm" class="row g-3 mb-3">
                <div class="col-md-2">
                    <label class="form-label">Año</label>
                    <select class="form-select select2" name="anio" id="filtroAnio">
                        <option value="">Todos</option>
                        <c:forEach var="a" items="${anios}">
                            <option value="${a}">${a}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Nivel</label>
                    <select class="form-select select2" name="nivel" id="filtroNivel">
                        <option value="">Todos</option>
                        <c:forEach var="n" items="${niveles}">
                            <option value="${n}">${n}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Grado</label>
                    <select class="form-select select2" name="grado" id="filtroGrado">
                        <option value="">Todos</option>
                        <c:forEach var="g" items="${grados}">
                            <option value="${g}">${g}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Sección</label>
                    <select class="form-select select2" name="seccion" id="filtroSeccion">
                        <option value="">Todas</option>
                        <c:forEach var="s" items="${secciones}">
                            <option value="${s}">${s}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Curso</label>
                    <select class="form-select select2" name="curso" id="filtroCurso">
                        <option value="">Todos</option>
                        <c:forEach var="c" items="${cursos}">
                            <option value="${c}">${c}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-outline-primary w-100">
                        <i class="fas fa-search me-1"></i> Filtrar
                    </button>
                </div>
            </form>

            <div class="table-responsive overflow-auto">
                <table id="tablaMalla" class="table table-hover table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>Año</th>
                            <th>Nivel</th>
                            <th>Grado</th>
                            <th>Sección</th>
                            <th>Curso</th>
                            <th>Docente</th>
                            
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="malla" items="${mallas}">
                            <tr>
                                <td>${malla.anio}</td>
                                <td>${malla.nivel}</td>
                                <td>${malla.grado}</td>
                                <td>${malla.seccion}</td>
                                <td>${malla.curso}</td>
                                <td>${malla.docente}</td>
                                <td>${malla.orden}</td>
                                <td>
                                    <span class="badge ${malla.activo == 1 ? 'bg-success' : 'bg-secondary'}">
                                        ${malla.activo == 1 ? 'Activo' : 'Inactivo'}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/malla?action=editar&id=${malla.idMalla}" class="btn btn-sm btn-outline-primary me-1" title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button class="btn btn-sm btn-outline-danger" onclick="confirmarEliminacion(${malla.idMalla})">
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


<jsp:include page="/includes/footer.jsp" />
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
    $(document).ready(function () {
        $('#tablaMalla').DataTable({
            language: { url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
            pageLength: 25,
            lengthMenu: [ [10, 25, 50, 100], [10, 25, 50, 100] ],
            lengthChange: true,
            responsive: true
            
        });
    });
    

    function confirmarEliminacion(id) {
        Swal.fire({
            title: '¿Eliminar Malla?',
            text: 'Esta acción no se puede deshacer.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#110d59',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Sí, eliminar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '${pageContext.request.contextPath}/malla?action=eliminar&id=' + id;
            }
        });
    }
</script>
</body>
</html>
