<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<nav id="sidebar" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="position-sticky pt-3">
        <div class="text-center mb-4">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo Escuela" class="img-fluid logo-sidebar">
            <h5 class="mt-2">Intranet Escolar</h5>
        </div>
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.servletPath eq '/dashboard.jsp' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard">
                    <i class="fas fa-home me-2"></i>
                    Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.servletPath eq '/perfil.jsp' ? 'active' : ''}" href="${pageContext.request.contextPath}/perfil">
                    <i class="fas fa-user me-2"></i>
                    Mi Perfil
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.servletPath eq '/asistencia.jsp' ? 'active' : ''}" href="${pageContext.request.contextPath}/asistencia">
                    <i class="fas fa-calendar-check me-2"></i>
                    Asistencia
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.servletPath eq '/calificaciones.jsp' ? 'active' : ''}" href="${pageContext.request.contextPath}/calificaciones">
                    <i class="fas fa-star me-2"></i>
                    Calificaciones
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.servletPath eq '/horario.jsp' ? 'active' : ''}" href="${pageContext.request.contextPath}/horario">
                    <i class="fas fa-clock me-2"></i>
                    Horario
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.servletPath eq '/examenes.jsp' ? 'active' : ''}" href="${pageContext.request.contextPath}/examenes">
                    <i class="fas fa-file-alt me-2"></i>
                    Exámenes
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.servletPath eq '/comunicados.jsp' ? 'active' : ''}" href="${pageContext.request.contextPath}/comunicados">
                    <i class="fas fa-bullhorn me-2"></i>
                    Comunicados
                </a>
            </li>
            <c:if test="${sessionScope.usuario.rol eq 'APODERADO'}">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.servletPath eq '/mis-hijos.jsp' ? 'active' : ''}" href="${pageContext.request.contextPath}/mis-hijos">
                        <i class="fas fa-child me-2"></i>
                        Mis Hijos
                    </a>
                </li>
            </c:if>
            <c:if test="${sessionScope.usuario.rol eq 'DOCENTE' || sessionScope.usuario.rol eq 'ADMIN'}">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.servletPath eq '/estudiantes.jsp' ? 'active' : ''}" href="${pageContext.request.contextPath}/estudiantes">
                        <i class="fas fa-user-graduate me-2"></i>
                        Estudiantes
                    </a>
                </li>
            </c:if>
            <c:if test="${sessionScope.usuario.rol eq 'ADMIN'}">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.servletPath eq '/administracion.jsp' ? 'active' : ''}" href="${pageContext.request.contextPath}/administracion">
                        <i class="fas fa-cogs me-2"></i>
                        Administración
                    </a>
                </li>
            </c:if>
        </ul>
        <hr>
        <div class="px-3 mt-4">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger w-100">
                <i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión
            </a>
        </div>
    </div>
</nav>