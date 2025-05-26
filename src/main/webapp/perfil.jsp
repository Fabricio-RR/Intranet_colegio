<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - Colegio Peruano Chino Diez de Octubre</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/dashboard.css">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <style>
        .profile-header {
            background-color: #0A0A3D;
            color: white;
            padding: 2rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            background-color: white;
            color: #0A0A3D;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: bold;
            margin-right: 2rem;
        }
        .profile-info h2 {
            margin-bottom: 0.5rem;
        }
        .profile-info p {
            margin-bottom: 0.25rem;
            opacity: 0.8;
        }
        .profile-section {
            margin-bottom: 2rem;
        }
        .profile-section-title {
            color: #0A0A3D;
            border-bottom: 2px solid #0A0A3D;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .form-label {
            font-weight: 500;
        }
        .badge-role {
            background-color: #0A0A3D;
            color: white;
            font-size: 0.9rem;
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="/includes/sidebar.jsp" />
            
            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <jsp:include page="/includes/header.jsp" />
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Mi Perfil</h1>
                </div>
                
                <!-- Perfil del usuario -->
                <div class="profile-header d-flex align-items-center">
                    <div class="profile-avatar">
                        ${sessionScope.usuario.nombres.charAt(0)}${sessionScope.usuario.apellidos.charAt(0)}
                    </div>
                    <div class="profile-info">
                        <h2>${sessionScope.usuario.nombreCompleto()}</h2>
                        <p><i class="bi bi-person-badge"></i> DNI: ${sessionScope.usuario.dni}</p>
                        <p><i class="bi bi-envelope"></i> ${sessionScope.usuario.correo}</p>
                    </div>
                </div>
                
                <!-- Información personal -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm profile-section">
                            <div class="card-body">
                                <h3 class="profile-section-title">Información Personal</h3>
                                <form id="formInfoPersonal">
                                    <div class="mb-3">
                                        <label for="nombres" class="form-label">Nombres</label>
                                        <input type="text" class="form-control" id="nombres" value="${sessionScope.usuario.nombres}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="apellidos" class="form-label">Apellidos</label>
                                        <input type="text" class="form-control" id="apellidos" value="${sessionScope.usuario.apellidos}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="dni" class="form-label">DNI</label>
                                        <input type="text" class="form-control" id="dni" value="${sessionScope.usuario.dni}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="correo" class="form-label">Correo Electrónico</label>
                                        <input type="email" class="form-control" id="correo" value="${sessionScope.usuario.correo}">
                                    </div>
                                    <div class="mb-3">
                                        <label for="telefono" class="form-label">Teléfono</label>
                                        <input type="text" class="form-control" id="telefono" value="${sessionScope.usuario.telefono}">
                                    </div>
                                    <button type="submit" class="btn btn-primary">Actualizar Información</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Cambio de contraseña -->
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm profile-section">
                            <div class="card-body">
                                <h3 class="profile-section-title">Cambiar Contraseña</h3>
                                <form id="formCambioPassword">
                                    <div class="mb-3">
                                        <label for="passwordActual" class="form-label">Contraseña Actual</label>
                                        <input type="password" class="form-control" id="passwordActual" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="passwordNueva" class="form-label">Nueva Contraseña</label>
                                        <input type="password" class="form-control" id="passwordNueva" required>
                                        <div class="form-text">La contraseña debe tener al menos 6 caracteres.</div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="passwordConfirmar" class="form-label">Confirmar Contraseña</label>
                                        <input type="password" class="form-control" id="passwordConfirmar" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Cambiar Contraseña</button>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Preferencias -->
                        <div class="card border-0 shadow-sm profile-section">
                            <div class="card-body">
                                <h3 class="profile-section-title">Preferencias</h3>
                                <form id="formPreferencias">
                                    <div class="mb-3 form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="notificacionesEmail" checked>
                                        <label class="form-check-label" for="notificacionesEmail">Recibir notificaciones por email</label>
                                    </div>
                                    <div class="mb-3 form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="mostrarCalificaciones" checked>
                                        <label class="form-check-label" for="mostrarCalificaciones">Mostrar calificaciones en dashboard</label>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Guardar Preferencias</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Formulario de información personal
        document.getElementById('formInfoPersonal').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Simulación de actualización
            const correo = document.getElementById('correo').value;
            const telefono = document.getElementById('telefono').value;
            
            // Aquí iría la lógica para enviar los datos al servidor
            
            alert('Información personal actualizada correctamente');
        });
        
        // Formulario de cambio de contraseña
        document.getElementById('formCambioPassword').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const passwordActual = document.getElementById('passwordActual').value;
            const passwordNueva = document.getElementById('passwordNueva').value;
            const passwordConfirmar = document.getElementById('passwordConfirmar').value;
            
            // Validación básica
            if (passwordNueva.length < 6) {
                alert('La nueva contraseña debe tener al menos 6 caracteres');
                return;
            }
            
            if (passwordNueva !== passwordConfirmar) {
                alert('Las contraseñas no coinciden');
                return;
            }
            
            // Aquí iría la lógica para enviar los datos al servidor
            
            alert('Contraseña actualizada correctamente');
            
            // Limpiar campos
            document.getElementById('passwordActual').value = '';
            document.getElementById('passwordNueva').value = '';
            document.getElementById('passwordConfirmar').value = '';
        });
        
        // Formulario de preferencias
        document.getElementById('formPreferencias').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const notificacionesEmail = document.getElementById('notificacionesEmail').checked;
            const mostrarCalificaciones = document.getElementById('mostrarCalificaciones').checked;
            
            // Aquí iría la lógica para enviar los datos al servidor
            
            alert('Preferencias guardadas correctamente');
        });
    </script>
</body>
</html>
