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
</head>
<body class="bg-white d-flex flex-column align-items-center justify-content-center min-vh-100">
    <header class="w-100 py-4 custom-header text-white text-center d-flex justify-content-center align-items-center">
        <h1 class="mb-0">COLEGIO PERUANO CHINO DIEZ DE OCTUBRE</h1>
        <img src="${pageContext.request.contextPath}/assets/img/EscudoCDO.png" alt="Escudo CDO" class="ml-3" style="width: 80px; height: 90px;">
    </header>

    <div class="container-fluid d-flex justify-content-center align-items-center flex-grow-1 px-3">
        <div class="bg-white shadow-lg rounded-lg p-4 w-100" style="max-width: 500px;">
            <h2 class="text-center text-muted mb-2">Ingresa tus datos para</h2>
            <h2 class="text-center custom-text font-weight-bold mb-4">iniciar sesión.</h2>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="dni" class="custom-text">DNI</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                        </div>
                        <input type="text" class="form-control" id="dni" name="dni"
                        placeholder="Ingrese su DNI" required pattern="[0-9]{8}" maxlength="8"
                        title="El DNI debe contener 8 dígitos numéricos." autocomplete="off">

                        <div class="input-group-append">
                            <span class="input-group-text hidden" id="dni-error-icon">
                                <i class="fas fa-times-circle"></i>
                            </span>
                        </div>
                    </div>
                    <small id="dni-error" class="error-message hidden"></small>
                </div>

                <div class="form-group">
                    <label for="password" class="custom-text">Contraseña</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        </div>
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="Ingrese su contraseña" required oninput="this.value = this.value.replace(/\s/g, '')"    pattern="^[^<>]+$"
                        title="La contraseña no puede estar vacía." autocomplete="off"><!--
                        <input type="password" class="form-control" id="password" name="password"
    placeholder="Ingrese su contraseña" required 
    pattern="^[^<>\s]+$"
    title="La contraseña no puede contener espacios ni los caracteres < o >." 
    autocomplete="off">-->
                        <div class="input-group-append">
                            <button class="btn btn-outline-secondary" type="button" id="togglePassword" aria-label="Mostrar/Ocultar contraseña">
                                <i class="fas fa-eye"></i>
                            </button>
                            <span class="input-group-text hidden" id="password-error-icon"><i class="fas fa-times-circle"></i></span>
                        </div>
                    </div>
                    <small id="password-error" class="error-message hidden"></small>
                </div>

                <!-- Mensaje de error -->
                <c:if test="${not empty error}">
                    <div id="errorMsg" class="alert alert-danger text-center" role="alert">
                        ${error}
                    </div>
                </c:if>
                
                <!-- Mensaje de éxito -->
                <c:if test="${not empty param.mensaje}">
                    <div id="successMsg" class="alert alert-success alert-dismissible fade show text-center" role="alert">
                         ${param.mensaje}
                    </div>
                </c:if>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-danger w-100 mt-3">Iniciar sesión</button>
                </div>
            </form>

            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/views/recuperar-password.jsp" class="small text-decoration-none custom-text">¿Olvidaste tu contraseña?</a>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/login.js"></script>
    <script>
        document.getElementById('password').addEventListener('input', function (e) {
        // Solo permite caracteres distintos de <, > y espacio
        let valor = this.value;
        let limpio = valor.replace(/[<>\s]/g, ''); // quita < > y espacios
        if (valor !== limpio) {
            this.value = limpio;
        }
    });
    </script>
</body>
</html>