<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seleccionar Rol - Intranet Escolar</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #110d59, #1a1570);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .selector-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            max-width: 500px;
            width: 90%;
        }
        
        .logo {
            width: 80px;
            height: 80px;
            background: #110d59;
            border-radius: 50%;
            margin: 0 auto 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
        }
        
        .welcome {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .user-name {
            color: #110d59;
            font-weight: bold;
            font-size: 1.3rem;
            margin-bottom: 0.5rem;
        }
        
        .subtitle {
            color: #6c757d;
            margin-bottom: 1.5rem;
        }
        
        .role-card {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
            text-decoration: none;
            color: inherit;
            display: block;
            transition: all 0.3s ease;
        }
        
        .role-card:hover {
            border-color: #110d59;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(17, 13, 89, 0.1);
            text-decoration: none;
            color: inherit;
        }
        
        .role-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            margin-right: 1rem;
        }
        
        .role-title {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        
        .role-desc {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .logout-link {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e9ecef;
        }
        
        .logout-link a {
            color: #6c757d;
            text-decoration: none;
            font-size: 0.9rem;
        }
        
        .logout-link a:hover {
            color: #110d59;
        }
        
        /* Responsive */
        @media (max-width: 576px) {
            .selector-container {
                padding: 1.5rem;
                margin: 1rem;
            }
            
            .role-card {
                padding: 0.75rem;
            }
            
            .role-icon {
                width: 40px;
                height: 40px;
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <div class="selector-container">
        <!-- Logo y bienvenida -->
        <div class="welcome">
            <div class="logo">
                <i class="fas fa-school"></i>
            </div>
            <div class="user-name">María González Pérez</div>
            <div class="subtitle">Selecciona tu rol de acceso</div>
        </div>
        
        <!-- Roles disponibles -->
        <div class="roles-list">
            <!-- Administrador -->
            <a href="${pageContext.request.contextPath}/dashboard/administrador" class="role-card">
                <div class="d-flex align-items-center">
                    <div class="role-icon" style="background: #dc3545;">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="role-title">Administrador</div>
                        
                    </div>
                    <div>
                        <i class="fas fa-arrow-right text-muted"></i>
                    </div>
                </div>
            </a>
            
            <!-- Docente -->
            <a href="${pageContext.request.contextPath}/dashboard/docente" class="role-card">
                <div class="d-flex align-items-center">
                    <div class="role-icon" style="background: #28a745;">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="role-title">Docente</div>
                        
                    </div>
                    <div>
                        <i class="fas fa-arrow-right text-muted"></i>
                    </div>
                </div>
            </a>
            
            <!-- Coordinador -->
            <a href="${pageContext.request.contextPath}/dashboard/coordinador" class="role-card">
                <div class="d-flex align-items-center">
                    <div class="role-icon" style="background: #6f42c1;">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="role-title">Coordinador Académico</div>
                        
                    </div>
                    <div>
                        <i class="fas fa-arrow-right text-muted"></i>
                    </div>
                </div>
            </a>
        </div>
        
        <!-- Logout -->
        <div class="logout-link">
            <a href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt me-1"></i>
                Cerrar Sesión
            </a>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Efecto de carga simple
        document.querySelectorAll('.role-card').forEach(card => {
            card.addEventListener('click', function() {
                this.style.opacity = '0.7';
                this.style.pointerEvents = 'none';
            });
        });
    </script>
</body>
</html>
