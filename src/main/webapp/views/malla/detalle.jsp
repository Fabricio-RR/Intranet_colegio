<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<div class="card border-0 shadow-sm">
  <div class="card-body p-3">
    <div class="table-responsive">
      <table id="tablaDetalleMalla" class="table table-hover table-sm align-middle mb-0">
        <caption class="visually-hidden">Detalle de cursos asignados</caption>
        <thead class="table-light">
          <tr class="text-center">
            <th scope="col">#</th>
            <th scope="col">Grado</th>
            <th scope="col">Sección</th>
            <th scope="col">Curso</th>
            <th scope="col">Docente</th>
            <th scope="col">Orden</th>
            <th scope="col">Estado</th>
          </tr>
        </thead>
        <tbody>
          <c:if test="${empty detalleMalla}">
            <tr>
              <td colspan="7" class="text-center text-secondary py-4">
                <i class="fas fa-info-circle me-2"></i>No hay cursos registrados.
              </td>
            </tr>
          </c:if>
          <c:forEach var="item" items="${detalleMalla}" varStatus="st">
            <tr>
              <td class="text-center">${st.index + 1}</td>
              <td>${item.grado}</td>
              <td>${item.seccion}</td>
              <td>${item.nombreCurso}</td>
              <td>
                <c:choose>
                  <c:when test="${not empty item.docente}">${item.docente}</c:when>
                  <c:otherwise><span class="text-muted fst-italic">— No asignado —</span></c:otherwise>
                </c:choose>
              </td>
              <td class="text-center">
                <c:choose>
                  <c:when test="${item.orden != null}">${item.orden}</c:when>
                  <c:otherwise>—</c:otherwise>
                </c:choose>
              </td>
              <td class="text-center">
                <span class="badge ${item.activo ? 'bg-success' : 'bg-danger'}">
                  ${item.activo ? 'Activo' : 'Inactivo'}
                </span>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>
<script>
  $(function() {
    $('#tablaDetalleMalla').DataTable({
      responsive: true,
      paging: false,
      searching: true,
      info: false,
      language: {
        search: 'Buscar:',
        zeroRecords: 'No se encontraron registros',
        paginate: {
          first: 'Primera', last: 'Última', next: 'Sig.', previous: 'Ant.'
        }
      }
    });
  });
</script>
