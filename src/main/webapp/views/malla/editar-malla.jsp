<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp"/>
    <title>Editar Malla Curricular</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">
<jsp:include page="/includes/sidebar.jsp" />
<jsp:include page="/includes/header.jsp" />
<main class="main-content container py-4">
    <h4 class="mb-4"><i class="fas fa-pen me-2"></i>Editar Asignación de Malla Curricular</h4>

    <form action="${pageContext.request.contextPath}/malla" method="post">
        <input type="hidden" name="action" value="actualizar"/>
        <input type="hidden" name="idMalla" value="${malla.idMalla}"/>

        <div class="row g-3">
            <div class="col-md-4">
                <label class="form-label">Curso</label>
                <input type="text" class="form-control" value="${malla.curso}" readonly>
            </div>
            <div class="col-md-4">
                <label class="form-label">Docente Asignado</label>
                <select name="idDocente" class="form-select">
                    <c:forEach var="docente" items="${docentes}">
                        <option value="${docente.id}" ${docente.id == malla.idDocente ? 'selected' : ''}>${docente.nombre}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label">Estado</label>
                <select name="activo" class="form-select">
                    <option value="1" ${malla.activo == 1 ? 'selected' : ''}>Activo</option>
                    <option value="0" ${malla.activo == 0 ? 'selected' : ''}>Inactivo</option>
                </select>
            </div>
        </div>

        <div class="mt-4 d-flex justify-content-end">
            <a href="${pageContext.request.contextPath}/malla?action=ver" class="btn btn-outline-secondary me-2">Cancelar</a>
            <button type="submit" class="btn btn-primary">Guardar Cambios</button>
        </div>
    </form>

<jsp:include page="/includes/footer.jsp" />
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
