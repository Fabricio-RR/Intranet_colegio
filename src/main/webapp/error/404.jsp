<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página no encontrada - Colegio Peruano Chino Diez de Octubre</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
        .error-image {
            max-width: 300px;
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
            <img src="${pageContext.request.contextPath}/assets/img/EscudoCDO.png" alt="Escudo CDO" class="ml-3" style="width: 100px; height: 150px; object-fit: contain;">
            <h1 class="error-code">404</h1>
            <h2 class="error-message">Página no encontrada</h2>
            <p class="error-description">
                Lo sentimos, la página que estás buscando no existe o ha sido movida.
                Por favor, verifica la URL o regresa a la página principal.
            </p>
            <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                <a href="${pageContext.request.contextPath}/views/dashboard.jsp" class="btn btn-primary btn-lg px-4 gap-3">
                    <i class="bi bi-house-door"></i> Ir al Dashboard
                </a>
                <button onclick="history.back()" class="btn btn-outline-secondary btn-lg px-4">
                    <i class="bi bi-arrow-left"></i> Volver atrás
                </button>
            </div>
        </div>
    </div>
</body>
</html>
