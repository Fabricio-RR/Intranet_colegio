<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="/includes/layout.jsp">
    <jsp:param name="title" value="Mis Hijos" />
    <jsp:attribute name="head">
        <!-- Estilos adicionales para mis hijos -->
    </jsp:attribute>
    <jsp:attribute name="actions">
        <!-- No hay acciones adicionales -->
    </jsp:attribute>
    <jsp:body>
        <!-- Lista de hijos -->
        <div class="row">
            <c:choose>
                <c:when test="${not empty hijos}">
                    <c:forEach items="${hijos}" var="hijo">
                        <div class="col-md-6 mb-4">
                            <div class="card h-100 fade-in">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">${hijo.nombre} ${hijo.apellido}</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-md-4">
                                            <div class="text-center mb-3">
                                                <c:choose>
                                                    <c:when test="${not empty hijo.foto}">
                                                        <img src="${pageContext.request.contextPath}/assets/img/estudiantes/${hijo.foto}" alt="${hijo.nombre}" class="img-fluid rounded-circle" style="width: 120px; height: 120px; object-fit: cover;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center text-white" style="width: 120px; height: 120px; font-size: 2.5rem; margin: 0 auto;">
                                                            ${fn:substring(hijo.nombre, 0, 1)}${fn:substring(hijo.apellido, 0, 1)}
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="col-md-8">
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                                    <span><i class="bi bi-person"></i> DNI:</span>
                                                    <span class="fw-bold">${hijo.dni}</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                                    <span><i class="bi bi-book"></i> Grado:</span>
                                                    <span class="fw-bold">${hijo.grado} - ${hijo.seccion}</span>
                                                </li>
                                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                                    <span><i class="bi bi-calendar3"></i> Edad:</span>
                                                    <span class="fw-bold">${hijo.edad} años</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    
                                    <!-- Resumen académico -->
                                    <div class="mb-3">
                                        <h6 class="border-bottom pb-2"><i class="bi bi-journal-check"></i> Resumen Académico</h6>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="card bg-light mb-2">
                                                    <div class="card-body py-2">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <span>Promedio General:</span>
                                                            <span class="fw-bold ${hijo.promedioGeneral >= 14 ? 'text-success' : hijo.promedioGeneral >= 11 ? 'text-primary' : 'text-danger'}">${hijo.promedioGeneral}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="card bg-light mb-2">
                                                    <div class="card-body py-2">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <span>Asistencia:</span>
                                                            <span class="fw-bold ${hijo.porcentajeAsistencia >= 90 ? 'text-success' : hijo.porcentajeAsistencia >= 80 ? 'text-primary' : 'text-danger'}">${hijo.porcentajeAsistencia}%</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Próximos exámenes -->
                                    <div class="mb-3">
                                        <h6 class="border-bottom pb-2"><i class="bi bi-pencil-square"></i> Próximos Exámenes</h6>
                                        <c:choose>
                                            <c:when test="${not empty hijo.proximosExamenes}">
                                                <div class="list-group list-group-flush">
                                                    <c:forEach items="${hijo.proximosExamenes}" var="examen" end="2">
                                                        <div class="list-group-item px-0">
                                                            <div class="d-flex justify-content-between align-items-center">
                                                                <span>${examen.curso}</span>
                                                                <span class="badge bg-danger"><fmt:formatDate value="${examen.fecha}" pattern="dd/MM/yyyy"/></span>
                                                            </div>
                                                            <small class="text-muted">${examen.tema}</small>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <c:if test="${fn:length(hijo.proximosExamenes) > 3}">
                                                    <div class="text-center mt-2">
                                                        <a href="${pageContext.request.contextPath}/examenes?hijo=${hijo.id}" class="btn btn-sm btn-outline-primary">Ver todos</a>
                                                    </div>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-info py-2">No hay exámenes próximos.</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <!-- Últimas calificaciones -->
                                    <div>
                                        <h6 class="border-bottom pb-2"><i class="bi bi-graph-up"></i> Últimas Calificaciones</h6>
                                        <c:choose>
                                            <c:when test="${not empty hijo.ultimasCalificaciones}">
                                                <div class="list-group list-group-flush">
                                                    <c:forEach items="${hijo.ultimasCalificaciones}" var="calificacion" end="2">
                                                        <div class="list-group-item px-0">
                                                            <div class="d-flex justify-content-between align-items-center">
                                                                <span>${calificacion.curso}</span>
                                                                <span class="nota-container ${calificacion.nota >= 14 ? 'nota-excelente' : calificacion.nota >= 11 ? 'nota-buena' : 'nota-mala'}">${calificacion.nota}</span>
                                                            </div>
                                                            <small class="text-muted">${calificacion.tipo} - <fmt:formatDate value="${calificacion.fecha}" pattern="dd/MM/yyyy"/></small>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="text-center mt-2">
                                                    <a href="${pageContext.request.contextPath}/calificaciones?hijo=${hijo.id}" class="btn btn-sm btn-outline-primary">Ver todas</a>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-info py-2">No hay calificaciones recientes.</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/horario?hijo=${hijo.id}" class="btn btn-sm btn-outline-secondary">
                                            <i class="bi bi-calendar3"></i> Horario
                                        </a>
                                        <a href="${pageContext.request.contextPath}/asistencia?hijo=${hijo.id}" class="btn btn-sm btn-outline-secondary">
                                            <i class="bi bi-person-check"></i> Asistencia
                                        </a>
                                        <a href="${pageContext.request.contextPath}/calificaciones?hijo=${hijo.id}" class="btn btn-sm btn-outline-secondary">
                                            <i class="bi bi-journal-check"></i> Calificaciones
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No tiene hijos registrados en el sistema.
                        </div>
                    </div>