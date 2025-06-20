<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${not empty matricula}">
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
            <p class="mb-2">${matricula.alumno.codigoMatricula}</p>
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
                    <p class="mb-2 text-capitalize">${matricula.apoderado.parentesco}</p>
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
                <div class="col-md-4">
                    <label class="fw-semibold">Nivel:</label>
                    <p class="mb-2">${matricula.nivel}</p>
                </div>
                <div class="col-md-4">
                    <label class="fw-semibold">Grado:</label>
                    <p class="mb-2">${matricula.grado}</p>
                </div>
                <div class="col-md-4">
                    <label class="fw-semibold">Sección:</label>
                    <p class="mb-2">${matricula.seccion}</p>
                </div>
                <div class="col-md-4">
                    <label class="fw-semibold">Fecha de Matrícula:</label>
                    <p class="mb-2"><fmt:formatDate value="${matricula.fecha}" pattern="dd/MM/yyyy" /></p>
                </div>
                <div class="col-md-4">
                    <label class="fw-semibold">Estado:</label>
                    <p class="mb-0 text-uppercase">
                        <span class="badge 
                            ${matricula.estado == 'regular' ? 'bg-success' : 
                              matricula.estado == 'condicional' ? 'bg-warning text-dark' : 
                              matricula.estado == 'egresado' ? 'bg-primary' : 
                              'bg-danger'}">
                            ${matricula.estado}
                        </span>
                    </p>
                </div>
                <div class="col-md-12">
                    <c:if test="${matricula.estado == 'condicional' && not empty matricula.observacion}">
                        <div class="alert alert-warning d-flex align-items-center mt-2" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <strong>Observación:</strong> ${matricula.observacion}
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <div class="text-end mt-3">
        <button type="button" class="btn btn-outline-danger btn-uniform" data-bs-dismiss="modal">
          <i class="fas fa-times me-1"></i> Cancelar
        </button>
      </div>
    </div>
</c:if>

<c:if test="${empty matricula}">
    <div class="alert alert-warning text-center" role="alert">
        <i class="fas fa-info-circle me-2"></i>No se encontró información de la matrícula.
    </div>
</c:if>
