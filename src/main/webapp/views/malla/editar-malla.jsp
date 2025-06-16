<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
  <h4 class="mb-4"><i class="fas fa-pen me-2"></i>Editar Malla Curricular - Nivel ${param.idNivel}</h4>
  <form id="formEditarMalla" method="post" action="${pageContext.request.contextPath}/malla-curricular">
    <input type="hidden" name="action" value="actualizarPorNivel" />
    <input type="hidden" name="idNivel" value="${param.idNivel}" />
    <input type="hidden" name="anio" value="${param.anio}" />

    <div class="table-responsive">
      <table class="table table-bordered align-middle table-sm">
        <thead class="table-light">
          <tr class="text-center">
            <th>#</th>
            <th>Curso</th>
            <th>Docente</th>
            <th>Orden</th>
            <th>Activo</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="item" items="${detalleMalla}" varStatus="st">
            <tr>
              <td class="text-center">${st.index + 1}</td>
              <td>${item.nombreCurso}</td>
              <td>
                <select name="idDocente_${item.idMalla}" class="form-select form-select-sm">
                  <option value="">-- Sin docente --</option>
                  <c:forEach var="doc" items="${docentes}">
                    <option value="${doc.idUsuario}"
                            <c:if test="${doc.idUsuario eq item.idDocente}">selected</c:if>>
                      ${doc.nombres} ${doc.apellidos}
                    </option>
                  </c:forEach>
                </select>
              </td>
              <td class="text-center">
                <input type="number" name="orden_${item.idMalla}" value="${item.orden}" class="form-control form-control-sm text-center" min="1" />
              </td>
              <td class="text-center">
                <input type="checkbox" name="activo_${item.idMalla}" ${item.activo ? 'checked' : ''} />
              </td>
              <input type="hidden" name="idMalla[]" value="${item.idMalla}" />
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
    <div class="text-end mt-3">
      <button type="submit" class="btn btn-admin-primary">
        <i class="fas fa-save me-1"></i>Guardar Cambios
      </button>
      <button type="button" class="btn btn-outline-secondary ms-2" data-bs-dismiss="modal">
        Cancelar
      </button>
    </div>
  </form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

