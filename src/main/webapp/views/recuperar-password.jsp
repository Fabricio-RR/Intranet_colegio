<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Recuperar Contraseña</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/img/EscudoCDO.png" type="image/png">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/recuperar-password.css" rel="stylesheet">
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
            <h2 class="text-center text-muted mb-2">Recuperación de</h2>
            <h2 class="text-center custom-text font-weight-bold mb-4">Contraseña</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle mr-2"></i> ${error}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </c:if>
            
            <c:if test="${not empty mensaje}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle mr-2"></i> ${mensaje}
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
            </c:if>
            
            <!-- Indicador de pasos -->
            <div class="step-indicator">
                <div class="step active" id="step1">1</div>
                <div class="step" id="step2">2</div>
                <div class="step" id="step3">3</div>
            </div>
            
            <!-- Paso 1 -->
            <div id="paso1">
                <h5 class="text-center mb-4 custom-text">Ingresa tu información</h5>
                <form id="formPaso1" action="${pageContext.request.contextPath}/recuperar-password" method="post">
                    <input type="hidden" name="paso" value="1">
                    <div class="form-group">
                        <label for="dni" class="custom-text">DNI</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                            </div>
                            <input type="text" class="form-control" id="dni" name="dni"
                            placeholder="Ingrese su DNI" 
                            required pattern="[0-9]{8}" maxlength="8"
                            inputmode="numeric"
                            title="El DNI debe contener exactamente 8 dígitos numéricos." autocomplete="off">
                        </div>
                    </div>
                    <label for="email" class="custom-text">Correo electrónico</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                        </div>
                        <input type="email" class="form-control" id="email" name="email"
                        required
                        placeholder="Ingrese su correo electrónico"
                        pattern="^[^<>\s/]+$"
                        title="No se permiten espacios ni los caracteres <, >, /"
                        autocomplete="off">
                    </div>                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-danger w-100 mt-3" id="btnPaso1">
                            <i class="fas fa-paper-plane mr-2"></i>Enviar código de verificación
                        </button>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary w-100 mt-2">
                            <i class="fas fa-arrow-left mr-2"></i>Volver al inicio de sesión
                        </a>
                    </div>
                </form>
            </div>

            <!-- Paso 2 -->
            <div id="paso2" style="display: none;">
                <h5 class="text-center mb-4 custom-text">Ingresa el código de verificación</h5>
                <p class="text-center text-muted mb-4">Hemos enviado un código de verificación a tu correo electrónico. Por favor, ingrésalo a continuación.</p>
                
                <form id="formPaso2" action="${pageContext.request.contextPath}/recuperar-password" method="post">
                    <input type="hidden" name="paso" value="2">
                    <input type="hidden" name="codigo" id="codigoInput">
                    <div class="verification-code">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="\d" class="code-input" autocomplete="off">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="\d" class="code-input" autocomplete="off">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="\d" class="code-input" autocomplete="off">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="\d" class="code-input" autocomplete="off">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="\d" class="code-input" autocomplete="off">
                        <input type="text" maxlength="1" inputmode="numeric" pattern="\d" class="code-input" autocomplete="off">
                    </div>
                    <div class="text-center mb-4">
                        <span id="countdown" class="text-muted">El código expira en: 05:00</span>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="button" class="btn btn-danger w-100 mt-3" id="btnPaso2">
                            <i class="fas fa-check-circle mr-2"></i>Verificar código
                        </button>
                        <button type="button" class="btn btn-link w-100" id="btnVolverPaso1">
                            <i class="fas fa-arrow-left mr-2"></i>Volver
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Paso 3 -->
            <div id="paso3" style="display: none;">
                <h5 class="text-center mb-4 custom-text">Crea una nueva contraseña</h5>
                    <div id="errorPaso3" class="alert alert-danger d-none" role="alert">
                        <i class="fas fa-exclamation-circle mr-2"></i>
                    <span id="mensajeErrorPaso3"></span>
                </div>
                <p class="text-center text-muted mb-4">Tu identidad ha sido verificada. Ahora puedes crear una nueva contraseña.</p>
                <form id="formPaso3" action="${pageContext.request.contextPath}/recuperar-password" method="post">
                    <input type="hidden" name="paso" value="3">
                    
                    <div class="form-group">
                        <label for="newPassword" class="custom-text">Nueva contraseña</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            </div>
                            <input type="password" class="form-control" id="newPassword" name="newPassword"
                            placeholder="Ingrese nueva contraseña" required
                            pattern="^[^<>\s/]{8,}$"
                            title="La contraseña debe tener al menos 8 caracteres.">

                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary" type="button" id="toggleNewPassword">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword" class="custom-text">Confirmar contraseña</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            </div><input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                            placeholder="Confirme nueva contraseña" required
                            pattern="^[^<>\s/]{8,}$"
                            title="La contraseña debe tener al menos 8 caracteres.">
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary" type="button" id="toggleConfirmPassword">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <div class="progress" style="height: 5px;">
                            <div class="progress-bar" id="passwordStrength" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <small id="passwordFeedback" class="form-text text-muted">La contraseña debe tener al menos 8 caracteres, incluyendo letras mayúsculas, minúsculas, números y caracteres especiales.</small>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-danger w-100 mt-3" id="btnPaso3">
                            <i class="fas fa-save mr-2"></i>Guardar nueva contraseña
                        </button>
                        <button type="button" class="btn btn-link w-100" id="btnVolverPaso2">
                            <i class="fas fa-arrow-left mr-2"></i>Volver
                        </button>
                    </div>
                </form>
            </div>
            
            <div class="text-center mt-3">
                <p class="text-muted small">Si continúas teniendo problemas, contacta con el administrador del sistema.</p>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/recuperar-password.js"></script>

    <c:if test="${not empty pasoActual}">
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const paso = '${pasoActual}';
                if (paso === '2') {
                    goToStep(2);
                    iniciarTemporizador(5 * 60);
                } else if (paso === '3') {
                    goToStep(3);
                } else {
                    goToStep(1);
                }
            });
        </script>
    </c:if>
</body>
</html>
