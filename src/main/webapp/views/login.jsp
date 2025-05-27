<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Inicio de Sesión</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet"/>
    
    <link href="${pageContext.request.contextPath}/assets/css/login.css" rel="stylesheet">
    <style>
        .custom-header {
            background-color: #0A0A3D;
        }
        .custom-text {
            color: #0A0A3D;
        }
        .error-message {
            color: red;
            font-size: 0.9em;
            display: none;
        }
        .input-error {
            border-color: #ff0000;
        }
        .input-group-append i {
            color: #ff0000;
        }
        .hidden {
            display: none;
        }
        @media (max-width: 576px) {
            .custom-header h1 {
                font-size: 1.2rem;
            }
            .custom-header img {
                width: 60px;
                height: 70px;
            }
        }
    </style>
</head>
<body class="bg-white d-flex flex-column align-items-center justify-content-center min-vh-100">
    <header class="w-100 py-4 custom-header text-white text-center d-flex justify-content-center align-items-center">
        <h1 class="mb-0">COLEGIO PERUANO CHINO DIEZ DE OCTUBRE</h1>
        <img src="${pageContext.request.contextPath}/assets/img/EscudoCDO.png" alt="Escudo CDO" class="ml-3" style="width: 80px; height: 90px; object-fit: contain;">
    </header>
    <div class="container-fluid d-flex justify-content-center align-items-center flex-grow-1 px-3">
        <div class="bg-white shadow-lg rounded-lg p-4 w-100" style="max-width: 500px;">
            <h2 class="text-center text-muted mb-2">Ingresa tus datos para</h2>
            <h2 class="text-center custom-text font-weight-bold mb-4">iniciar sesión.</h2>

            <form action="login" method="post">
                <div class="form-group">
                    <label for="dni" class="custom-text">DNI</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text custom-input-group-text"><i class="fas fa-user"></i></span>
                        </div>
                        <input type="text" class="form-control" id="dni" name="dni" placeholder="Ingrese su DNI" required aria-label="DNI de usuario">
                        <div class="input-group-append">
                            <span class="input-group-text <%= (request.getAttribute("error") != null) ? "" : "hidden" %>" id="dni-error-icon"><i class="fas fa-times-circle"></i></span>
                        </div>
                    </div>
                    <small id="dni-error" class="error-message <%= (request.getAttribute("error") != null) ? "" : "hidden" %>"><%= (request.getAttribute("error") != null) ? request.getAttribute("error") : "El DNI ingresado no es válido." %></small>
                </div>

                <div class="form-group">
                    <label for="password" class="custom-text">Contraseña</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text custom-input-group-text"><i class="fas fa-lock"></i></span>
                        </div>
                        <input type="password" class="form-control" id="password" name="password" placeholder="Ingrese su contraseña" required aria-label="Contraseña">
                        <div class="input-group-append">
                            <button class="btn btn-outline-secondary" type="button" id="togglePassword" aria-label="Mostrar/Ocultar contraseña">
                                <i class="fas fa-eye"></i>
                            </button>
                            <span class="input-group-text <%= (request.getAttribute("error") != null) ? "" : "hidden" %>" id="password-error-icon"><i class="fas fa-times-circle"></i></span>
                        </div>
                    </div>
                    <small id="password-error" class="error-message <%= (request.getAttribute("error") != null) ? "" : "hidden" %>"><%= (request.getAttribute("error") != null) ? request.getAttribute("error") : "La contraseña es incorrecta." %></small>
                </div>
                <!--
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                    <label class="form-check-label custom-text" for="rememberMe">Recordar sesión</label>
                </div>
                -->
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-danger w-100 mt-3">Iniciar sesión</button>
                </div>
            </form>

            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/recuperar-password.jsp" class="small text-decoration-none custom-text">¿Olvidaste tu contraseña?</a>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/login.js"></script>
</body>
</html>