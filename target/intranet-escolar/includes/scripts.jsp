<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery (si es necesario) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- Font Awesome -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>

<!-- Scripts comunes -->
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

<!-- Script para manejo de sesión -->
<script>
    // Verificar sesión cada 5 minutos
    setInterval(function() {
        fetch('${pageContext.request.contextPath}/controller/auth?action=checkSession')
            .then(response => response.json())
            .then(data => {
                if (!data.valid) {
                    alert('Su sesión ha expirado. Será redirigido al login.');
                    window.location.href = '${pageContext.request.contextPath}/login.jsp';
                }
            })
            .catch(error => console.error('Error verificando sesión:', error));
    }, 300000); // 5 minutos
</script>
