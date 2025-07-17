<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Acceso denegado - Colegio Peruano Chino Diez de Octubre</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-size: 16px;
        }
        .error-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 40px 20px;
            text-align: center;
        }
        .error-code {
            font-size: 120px;
            font-weight: bold;
            color: #0A0A3D;
            margin-bottom: 0;
            line-height: 1;
        }
        .error-message {
            font-size: 24px;
            color: #6c757d;
            margin-bottom: 30px;
        }
        .error-description {
            color: #6c757d;
            margin-bottom: 30px;
        }
        .btn-primary {
            background-color: #0A0A3D;
            border-color: #0A0A3D;
        }
        .btn-primary:hover {
            background-color: #050527;
            border-color: #050527;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-container">
            <img src="${pageContext.request.contextPath}/assets/img/EscudoCDO.png"
                 alt="Escudo CDO"
                 class="mb-4 d-block mx-auto"
                 style="width: 100px; height: 150px; object-fit: contain;">
            <h1 class="error-code">403</h1>
            <h2 class="error-message">Acceso denegado</h2>
            <p class="error-description">
                No tienes permisos para acceder a esta sección.<br>
                Si crees que esto es un error, contacta con el administrador del sistema.
            </p>
            <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                <button onclick="history.back()" class="btn btn-outline-secondary btn-lg px-4">
                    <i class="bi bi-arrow-left"></i> Volver atrás
                </button>
                <a href="${pageContext.request.contextPath}/" class="btn btn-admin-primary btn-lg px-4 ms-4 text-decoration-none">
                    <i class="bi bi-house"></i> Ir al inicio
                </a>
            </div>
        </div>
    </div>
</body>
</html>
