<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Gestionar Malla Curricular - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Gestionar Malla Curricular" scope="request" />
<c:set var="tituloPaginaMobile" value="Malla" scope="request" />
<c:set var="iconoPagina" value="fas fa-layer-group" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container-fluid">

        <!-- Tabs de selección -->
        <ul class="nav nav-tabs mb-4" id="mallaTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="tab-manual" type="button" onclick="mostrarSeccion('manual')">
                    <i class="fas fa-pen me-1"></i> Crear Manual
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="tab-masiva" type="button" onclick="mostrarSeccion('masiva')">
                    <i class="fas fa-layer-group me-1"></i> Crear Masiva
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="tab-copiar" type="button" onclick="mostrarSeccion('copiar')">
                    <i class="fas fa-copy me-1"></i> Copiar Malla
                </button>
            </li>
        </ul>

        <!-- Crear Manual -->
        <div id="formManual" class="formulario-malla">
            <form action="${pageContext.request.contextPath}/malla?action=crear" method="post">
                <div class="card mb-4">
                    <div class="card-header bg-light"><i class="fas fa-info-circle me-2"></i>Información Académica</div>
                    <div class="card-body row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Año Lectivo</label>
                            <select name="idAnioLectivo" class="form-select" required>
                                <c:forEach var="anio" items="${anios}">
                                    <option value="${anio.idAnio}" ${anio.actual ? 'selected' : ''}>${anio.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Nivel</label>
                            <select name="idNivel" class="form-select" required>
                                <option value="" disabled selected>Seleccione nivel</option>
                                <c:forEach var="nivel" items="${niveles}">
                                    <option value="${nivel.idNivel}">${nivel.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Grado</label>
                            <select name="idGrado" class="form-select" required>
                                <option value="" disabled selected>Seleccione grado</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Sección</label>
                            <select name="idSeccion" class="form-select" required>
                                <option value="" disabled selected>Seleccione sección</option>
                                <c:forEach var="seccion" items="${secciones}">
                                    <option value="${seccion.idSeccion}">${seccion.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header bg-light"><i class="fas fa-chalkboard-teacher me-2"></i>Asignación de Curso y Docente</div>
                    <div class="card-body row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Curso</label>
                            <select name="idCurso" class="form-select" required>
                                <option value="" disabled selected>Seleccione curso</option>
                                <c:forEach var="curso" items="${cursos}">
                                    <option value="${curso.idCurso}">${curso.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Docente</label>
                            <select name="idDocente" class="form-select" required>
                                <option value="" disabled selected>Seleccione docente</option>
                                <c:forEach var="docente" items="${docentes}">
                                    <option value="${docente.idUsuario}">${docente.nombres} ${docente.apellidos}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header bg-light"><i class="fas fa-cogs me-2"></i>Configuración</div>
                    <div class="card-body row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Orden</label>
                            <input type="number" name="orden" class="form-control" min="1" required />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Estado</label>
                            <select name="activo" class="form-select" required>
                                <option value="1" selected>Activo</option>
                                <option value="0">Inactivo</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/malla" class="btn btn-outline-danger">
                        <i class="fas fa-arrow-left me-1"></i> Cancelar
                    </a>
                    <button type="submit" class="btn btn-admin-primary">
                        <i class="fas fa-save me-1"></i> Guardar Malla
                    </button>
                </div>
            </form>
        </div>

        <div id="formMasiva" class="formulario-malla d-none">
    <form action="${pageContext.request.contextPath}/malla?action=masiva" method="post">
        <div class="card mb-4">
            <div class="card-header bg-light">
                <i class="fas fa-layer-group me-2"></i>Asignación Masiva de Cursos y Docentes
            </div>
            <div class="card-body row g-3">
                <div class="col-md-3">
                    <label class="form-label">Año Lectivo</label>
                    <select name="idAnioLectivo" class="form-select" required>
                        <c:forEach var="anio" items="${anios}">
                            <option value="${anio.idAnio}" ${anio.actual ? 'selected' : ''}>${anio.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Nivel</label>
                    <select name="idNivel" class="form-select" required>
                        <option value="" disabled selected>Seleccione nivel</option>
                        <c:forEach var="nivel" items="${niveles}">
                            <option value="${nivel.idNivel}">${nivel.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Grado</label>
                    <select name="idGrado" class="form-select" required>
                        <option value="" disabled selected>Seleccione grado</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Sección</label>
                    <select name="idSeccion" class="form-select" required>
                        <option value="" disabled selected>Seleccione sección</option>
                        <c:forEach var="seccion" items="${secciones}">
                            <option value="${seccion.idSeccion}">${seccion.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="table-responsive mt-4">
                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>Curso</th>
                            <th>Docente</th>
                            <th>Orden</th>
                            <th>Activo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="curso" items="${cursos}">
                            <tr>
                                <td>
                                    <input type="hidden" name="idCurso[]" value="${curso.idCurso}" />
                                    ${curso.nombre}
                                </td>
                                <td>
                                    <select name="idDocente[]" class="form-select" required>
                                        <option value="">Seleccione</option>
                                        <c:forEach var="docente" items="${docentes}">
                                            <option value="${docente.idUsuario}">${docente.nombres} ${docente.apellidos}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td><input type="number" name="orden[]" class="form-control" min="1" required /></td>
                                <td>
                                    <select name="activo[]" class="form-select">
                                        <option value="1">Sí</option>
                                        <option value="0">No</option>
                                    </select>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="card-footer text-end">
                <button type="submit" class="btn btn-admin-primary">
                    <i class="fas fa-save me-1"></i>Guardar Malla Masiva
                </button>
            </div>
        </div>
    </form>
</div>
        <div id="formCopiar" class="formulario-malla d-none">
    <form action="${pageContext.request.contextPath}/malla?action=copiar" method="post">
        <div class="card">
            <div class="card-header bg-light">
                <i class="fas fa-copy me-2"></i>Copiar Malla del Año Anterior
            </div>
            <div class="card-body row g-3">
                <div class="col-md-4">
                    <label class="form-label">Año Origen</label>
                    <select name="anioOrigen" class="form-select" required>
                        <c:forEach var="a" items="${anios}">
                            <option value="${a.idAnio}">${a.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Año Destino</label>
                    <select name="anioDestino" class="form-select" required>
                        <c:forEach var="a" items="${anios}">
                            <option value="${a.idAnio}" ${a.actual ? 'selected' : ''}>${a.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Grado</label>
                    <select name="idGrado" class="form-select" required></select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Sección</label>
                    <select name="idSeccion" class="form-select" required>
                        <c:forEach var="s" items="${secciones}">
                            <option value="${s.idSeccion}">${s.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="card-footer text-end">
                <button type="submit" class="btn btn-admin-primary">
                    <i class="fas fa-copy me-1"></i> Copiar Malla
                </button>
            </div>
        </div>
    </form>
</div>

    </div>
    <jsp:include page="/includes/footer.jsp" />
</main>

<script>
    function mostrarSeccion(tipo) {
        const secciones = ['formManual', 'formMasiva', 'formCopiar'];
        const tabs = ['tab-manual', 'tab-masiva', 'tab-copiar'];

        secciones.forEach((id, index) => {
            document.getElementById(id).classList.add('d-none');
            document.getElementById(tabs[index]).classList.remove('active');
        });

        document.getElementById('form' + tipo.charAt(0).toUpperCase() + tipo.slice(1)).classList.remove('d-none');
        document.getElementById('tab-' + tipo).classList.add('active');
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/crear-malla.js"></script>
</body>
</html>
