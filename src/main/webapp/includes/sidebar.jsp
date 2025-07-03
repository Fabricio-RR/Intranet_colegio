<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty sessionScope.usuario || empty sessionScope.rolActivo}">
    <c:redirect url="/views/login.jsp" />
</c:if>

<nav id="sidebar" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="position-sticky pt-3">
        <ul class="nav flex-column">

            <!-- Logo del colegio -->
            <div class="text-center mb-4">
                <img src="${pageContext.request.contextPath}/assets/img/EscudoCDO.png" alt="Escudo CDO"
                     style="width: 100px; height: 150px; object-fit: contain;">
                <h5 class="mt-2">Intranet Escolar</h5>
            </div>

            <!-- Opción fija: Dashboard -->
            <li class="nav-item">
                <a class="nav-link${fn:toLowerCase(paginaActiva) == 'dashboard' ? ' active' : ''}"
                   href="${pageContext.request.contextPath}/dashboard/${sessionScope.rolActivo}">
                    <i class="fas fa-tachometer-alt me-2"></i>
                    Dashboard
                </a>
            </li>

            <!-- Menú dinámico según permisos del rol activo -->
            <c:if test="${not empty sessionScope.menuItems}">
                <c:forEach items="${sessionScope.menuItems}" var="menu">
                    <li class="nav-item">
                        <a class="nav-link${fn:toLowerCase(menu.titulo) == fn:toLowerCase(paginaActiva) ? ' active' : ''}"
                           href="${pageContext.request.contextPath}${menu.url}">
                            <i class="${menu.icono} me-2"></i>
                            ${menu.titulo}
                        </a>
                    </li>
                </c:forEach>
            </c:if>

            <hr class="my-3">

            <!-- Opción fija: Ayuda -->
            <li class="nav-item">
                <a href="mailto:cdo10.soporte@gmail.com?subject=Ayuda%20Soporte%20Intranet%20Escolar"
                    class="nav-link"
                    data-bs-toggle="tooltip"
                    data-bs-html="true"
                    data-bs-placement="right"
                    title='<i class="fas fa-envelope"></i> cdo10.soporte@gmail.com'>
                    <i class="fas fa-question-circle"></i> Ayuda
                </a>
            </li>
        </ul>
    </div>
</nav>
