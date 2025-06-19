<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${not empty matricula}">
<form id="formEditarMatricula" method="post" action="${pageContext.request.contextPath}/matricula">
    <input type="hidden" name="action" value="editarGuardar"/>
    <input type="hidden" name="idMatricula" value="${matricula.idMatricula}"/>

    <div class="row g-3">
        <!-- Alumno -->
        <div class="col-md-6">
            <h5 class="fw-bold mb-3"><i class="fas fa-user-graduate me-2"></i>Alumno</h5>
            <label class="fw-semibold">DNI:</label>
            <p class="mb-2">${matricula.alumno.usuario.dni}</p>

            <label class="fw-semibold">Nombre completo:</label>
            <p class="mb-2">${matricula.alumno.usuario.nombres} ${matricula.alumno.usuario.apellidos}</p>

            <label class="fw-semibold">Correo:</label>
            <p class="mb-2">${matricula.alumno.usuario.correo}</p>

            <label class="fw-semibold">Teléfono:</label>
            <p class="mb-2">${matricula.alumno.usuario.telefono}</p>

            <label class="fw-semibold">Código de Matrícula:</label>
            <input type="text" class="form-control mb-2" name="codigoMatricula" 
                   value="${matricula.alumno.codigoMatricula}" maxlength="20" required/>
        </div>

        <!-- Apoderado -->
        <div class="col-md-6">
            <h5 class="fw-bold mb-3"><i class="fas fa-user-shield me-2"></i>Apoderado</h5>
            <c:choose>
                <c:when test="${not empty matricula.apoderado}">
                    <label class="fw-semibold">DNI:</label>
                    <p class="mb-2">${matricula.apoderado.usuario.dni}</p>

                    <label class="fw-semibold">Nombre completo:</label>
                    <p class="mb-2">${matricula.apoderado.usuario.nombres} ${matricula.apoderado.usuario.apellidos}</p>

                    <label class="fw-semibold">Correo:</label>
                    <p class="mb-2">${matricula.apoderado.usuario.correo}</p>

                    <label class="fw-semibold">Teléfono:</label>
                    <p class="mb-2">${matricula.apoderado.usuario.telefono}</p>

                    <label class="fw-semibold">Parentesco:</label>
                    <input type="text" class="form-control mb-2" name="parentesco" 
                           value="${matricula.apoderado.parentesco}" maxlength="30" required/>
                </c:when>
                <c:otherwise>
                    <p class="text-muted">No se registró apoderado.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Detalle Académico -->
        <div class="col-md-12 mt-3">
            <h5 class="fw-bold"><i class="fas fa-book-reader me-2"></i>Detalle Académico</h5>
            <div class="row">
                <div class="col-md-3">
                    <label class="fw-semibold">Nivel:</label>
                    <select class="form-select mb-2" name="nivel" required>
                        <c:forEach var="n" items="${niveles}">
                            <option value="${n.idNivel}" ${matricula.idNivel == n.idNivel ? 'selected' : ''}>${n.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="fw-semibold">Grado:</label>
                    <select class="form-select mb-2" name="grado" required>
                        <c:forEach var="g" items="${grados}">
                            <option value="${g.idGrado}" ${matricula.idGrado == g.idGrado ? 'selected' : ''}>${g.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="fw-semibold">Sección:</label>
                    <select class="form-select mb-2" name="seccion" required>
                        <c:forEach var="s" items="${secciones}">
                            <option value="${s.idSeccion}" ${matricula.idSeccion == s.idSeccion ? 'selected' : ''}>${s.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="fw-semibold">Estado:</label>
                    <select class="form-select mb-2" name="estado" required>
                        <option value="regular" ${matricula.estado == 'regular' ? 'selected' : ''}>Regular</option>
                        <option value="condicional" ${matricula.estado == 'condicional' ? 'selected' : ''}>Condicional</option>
                        <option value="retirado" ${matricula.estado == 'retirado' ? 'selected' : ''}>Retirado</option>
                    </select>
                </div>
            </div>
        </div>
    </div>

    <!-- Botones -->
    <div class="mt-4 d-flex justify-content-end gap-2">
        <button type="submit" class="btn btn-admin-primary">
            <i class="fas fa-save me-1"></i> Guardar cambios
        </button>
        <a href="${pageContext.request.contextPath}/matricula" class="btn btn-outline-secondary">
            <i class="fas fa-times me-1"></i> Cancelar
        </a>
    </div>
</form>
</c:if>

<c:if test="${empty matricula}">
    <div class="alert alert-warning text-center" role="alert">
        <i class="fas fa-info-circle me-2"></i>No se encontró información de la matrícula.
    </div>
</c:if>
