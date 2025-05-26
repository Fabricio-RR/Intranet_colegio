<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<footer class="footer mt-auto py-3 bg-light border-top">
    <div class="container-fluid">
        <div class="row align-items-center">
            <div class="col-md-6">
                <span class="text-muted">
                    © <fmt:formatDate value="${now}" pattern="yyyy" /> Intranet Escolar. 
                    Todos los derechos reservados.
                </span>
            </div>
            <div class="col-md-6 text-md-end">
                <span class="text-muted">
                    Versión 1.0 | 
                    <a href="${pageContext.request.contextPath}/views/soporte/index.jsp" class="text-decoration-none">
                        Soporte Técnico
                    </a>
                </span>
            </div>
        </div>
    </div>
</footer>
