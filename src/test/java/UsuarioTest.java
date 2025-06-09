
import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.model.entity.Usuario;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;
import org.mindrot.jbcrypt.BCrypt;


public class UsuarioTest {
 
    // --- LOGIN ---
 @Test
    public void testLoginUsuarioValido() {
        // Datos que EXISTEN en tu base de datos
        String dni = "12345678";
        String clave = "123456"; 
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = dao.login(dni, clave);

        assertNotNull(usuario, "El usuario no debe ser null si el login es válido");
        assertEquals(dni, usuario.getDni(), "El DNI debe coincidir con el ingresado");
    }

    @Test
    public void testLoginUsuarioInvalido() {
        // Datos que NO existen
        String dni = "9878999";
        String clave = "1234569";

        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = dao.login(dni, clave);

        assertNull(usuario, "El usuario debe ser null si las credenciales son inválidas");
    }
    
    // --- CREACIÓN DE USUARIOS ---
    @Test
    public void testCrearUsuarioExitosamente() throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setDni("99999980");
        usuario.setNombres("Juan");
        usuario.setApellidos("Pérez");
        usuario.setCorreo("juano@test.com");
        usuario.setClave("123456");
        usuario.setEstado(true);
        usuario.setFecRegistro(new Date());

        List<Integer> roles = Arrays.asList(1, 2);

        UsuarioDAO dao = new UsuarioDAO();
        boolean resultado = dao.crearUsuarioConRoles(usuario, roles);
        assertTrue(resultado);
    }

    // --- RESTABLECER CLAVE ADMIN ---
    @Test
    public void testClaveHasheadaEsValida() {
        String nuevaClave = "temporal123";
        String hash = BCrypt.hashpw(nuevaClave, BCrypt.gensalt());
        assertTrue(BCrypt.checkpw(nuevaClave, hash));
    }
}