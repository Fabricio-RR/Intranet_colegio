<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav id="sidebar" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="position-sticky pt-3">
        <ul class="nav flex-column">
            <div class="text-center mb-4">
            <img src="${pageContext.request.contextPath}/assets/img/EscudoCDO.png" alt="Escudo CDO" class="ml-3" style="width: 100px; height: 150px; object-fit: contain;">
            <h5 class="mt-2">Intranet Escolar</h5>
            </div>
            <!-- Dashboard -->
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/views/dashboard.jsp">
                    <i class="fas fa-tachometer-alt me-2"></i>
                    Dashboard
                </a>
            </li>

            <!-- Menú dinámico basado en permisos -->
            <c:if test="${not empty sessionScope.menuItems}">
                <c:forEach items="${sessionScope.menuItems}" var="menu">
                    <c:choose>
                        <c:when test="${not empty menu.submenu}">
                            <!-- Menú con submenús -->
                            <li class="nav-item">
                                <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#${menu.id}">
                                    <i class="${menu.icono} me-2"></i>
                                    ${menu.titulo}
                                    <i class="fas fa-chevron-down ms-auto"></i>
                                </a>
                                <div class="collapse" id="${menu.id}">
                                    <ul class="nav flex-column ms-3">
                                        <c:forEach items="${menu.submenu}" var="submenu">
                                            <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}${submenu.url}">
                                                    <i class="${submenu.icono} me-2"></i>
                                                    ${submenu.titulo}
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <!-- Menú simple -->
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}${menu.url}">
                                    <i class="${menu.icono} me-2"></i>
                                    ${menu.titulo}
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </c:if>

            <!-- Separador -->
            <hr class="my-3">

            <!-- Enlaces adicionales -->
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/views/ayuda/index.jsp">
                    <i class="fas fa-question-circle me-2"></i>
                    Ayuda
                </a>
            </li>
        </ul>
    </div>
</nav>
