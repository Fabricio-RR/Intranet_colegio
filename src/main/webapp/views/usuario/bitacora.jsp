<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${not empty usuario}">
    <div class="mb-3">
        <strong>Usuario:</strong> ${usuario.nombres} ${usuario.apellidos} (${usuario.dni})<br />
        <strong>Correo:</strong> ${usuario.correo}
    </div>
</c:if>

<table class="table table-striped table-bordered table-hover table-sm">
    <thead class="table-light">
        <tr>
            <th>#</th>
            <th>Módulo</th>
            <th>Acción</th>
            <th>Fecha</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="registro" items="${registros}" varStatus="i">
            <tr>
                <td>${i.index + 1}</td>
                <td>${registro.modulo}</td>
                <td>${registro.accion}</td>
                <td><fmt:formatDate value="${registro.fecha}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
            </tr>
        </c:forEach>
        <c:if test="${empty registros}">
            <tr>
                <td colspan="4" class="text-center text-muted">No hay registros disponibles.</td>
            </tr>
        </c:if>
    </tbody>
</table>
