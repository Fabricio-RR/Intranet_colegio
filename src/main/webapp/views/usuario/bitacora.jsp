<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- DataTables CSS -->
<link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>


<c:if test="${not empty usuario}">
    <div class="mb-3">
        <strong>Usuario:</strong> ${usuario.nombres} ${usuario.apellidos} (${usuario.dni})<br />
        <strong>Correo:</strong> ${usuario.correo}
    </div>
</c:if>

<table id="tablaBitacora" class="table table-striped table-bordered table-hover table-sm">
    <thead class="table-light">
        <tr>
            <th>#</th>
            <th>Módulo</th>
            <th>Acción</th>
            <th>Fecha</th>
        </tr>
    </thead>

    <c:choose>
        <c:when test="${empty registros}">
            <tfoot>
                <tr>
                    <td colspan="4" class="text-center text-muted">No hay registros disponibles.</td>
                </tr>
            </tfoot>
        </c:when>
        <c:otherwise>
            <tbody>
                <c:forEach var="registro" items="${registros}" varStatus="i">
                    <tr>
                        <td>${i.index + 1}</td>
                        <td>${registro.modulo}</td>
                        <td>${registro.accion}</td>
                        <td><fmt:formatDate value="${registro.fecha}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </c:otherwise>
    </c:choose>
</table>
<script>
$(document).ready(function () {
    $('#tablaBitacora').DataTable({
        language: {
            url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
        },
        pageLength: 10,
        lengthMenu: [ [10, 25, 50, 100], [10, 25, 50, 100] ],
        order: [[3, 'desc']], // ordenar por fecha descendente
        responsive: true
    });
});
</script>
