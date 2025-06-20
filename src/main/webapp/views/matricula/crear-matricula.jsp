<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container mt-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/matricula"><i class="fas fa-list"></i> Matrículas</a></li>
            <li class="breadcrumb-item active" aria-current="page">Crear Matrícula</li>
        </ol>
    </nav>

    <!-- Card principal -->
    <div class="card mb-4 shadow-sm">
        <div class="card-header fw-semibold"><i class="fas fa-user-plus me-2"></i>Información de Matrícula</div>
        <div class="card-body">
            <form id="formCrearMatricula" method="post" action="${pageContext.request.contextPath}/matricula">
                <input type="hidden" name="action" value="crearGuardar"/>
                <div class="row g-3 align-items-end">

                    <!-- Año lectivo -->
                    <div class="col-md-4">
                        <label for="anioLectivo" class="form-label fw-semibold">Año lectivo <span class="text-danger">*</span></label>
                        <select id="anioLectivo" name="anioLectivo" class="form-select" required>
                            <option value="" disabled selected>Seleccione año</option>
                            <c:forEach var="anio" items="${aniosLectivos}">
                                <option value="${anio.idAnioLectivo}">${anio.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Alumno -->
                    <div class="col-md-4">
                        <label for="idAlumno" class="form-label fw-semibold">Alumno <span class="text-danger">*</span></label>
                        <select id="idAlumno" name="idAlumno" class="form-select" required>
                            <option value="" disabled selected>Seleccione alumno</option>
                            <c:forEach var="al" items="${alumnosDisponibles}">
                                <option value="${al.idAlumno}">
                                    ${al.usuario.dni} - ${al.usuario.apellidos}, ${al.usuario.nombres}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Apoderado -->
                    <div class="col-md-4">
                        <label for="idApoderado" class="form-label fw-semibold">Apoderado <span class="text-danger">*</span></label>
                        <select id="idApoderado" name="idApoderado" class="form-select" required>
                            <option value="" disabled selected>Seleccione apoderado</option>
                            <c:forEach var="apo" items="${apoderadosDisponibles}">
                                <option value="${apo.idApoderado}">
                                    ${apo.usuario.dni} - ${apo.usuario.apellidos}, ${apo.usuario.nombres}
                                </option>
                            </c:forEach>
                        </select>
                        <small class="text-muted">¿No encuentra al apoderado? <a href="${pageContext.request.contextPath}/usuarios?action=nuevo" target="_blank">Registrar nuevo apoderado</a></small>
                    </div>

                    <!-- Parentesco -->
                    <div class="col-md-2">
                        <label for="parentesco" class="form-label fw-semibold">Parentesco <span class="text-danger">*</span></label>
                        <select id="parentesco" name="parentesco" class="form-select" required>
                            <option value="" disabled selected>Seleccione</option>
                            <option value="Padre">Padre</option>
                            <option value="Madre">Madre</option>
                            <option value="Tutor">Tutor</option>
                            <option value="Otro">Otro</option>
                        </select>
                    </div>

                    <!-- Nivel - Grado - Sección -->
                    <div class="col-md-4">
                        <label for="idAperturaSeccion" class="form-label fw-semibold">Nivel / Grado / Sección <span class="text-danger">*</span></label>
                        <select id="idAperturaSeccion" name="idAperturaSeccion" class="form-select" required>
                            <option value="" disabled selected>Seleccione sección</option>
                            <c:forEach var="aps" items="${aperturasSeccion}">
                                <option value="${aps.idAperturaSeccion}">
                                    ${aps.nivel} - ${aps.grado} "${aps.seccion}"
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- Estado -->
                    <div class="col-md-2">
                        <label for="estado" class="form-label fw-semibold">Estado <span class="text-danger">*</span></label>
                        <select id="estado" name="estado" class="form-select" required>
                            <option value="REGULAR">Regular</option>
                            <option value="CONDICIONAL">Condicional</option>
                        </select>
                    </div>

                    <!-- Botones -->
                    <div class="col-12 mt-4 d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/matricula" class="btn btn-outline-danger btn-uniform">
                            <i class="fas fa-arrow-left me-1"></i>Cancelar
                        </a>
                        <div>
                            <button type="reset" class="btn btn-outline-success btn-uniform me-2">
                                <i class="fas fa-eraser me-1"></i>Limpiar
                            </button>
                            <button type="submit" class="btn btn-primary btn-uniform">
                                <i class="fas fa-save me-1"></i>Crear Matrícula
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
