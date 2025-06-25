package mockito;
import com.intranet_escolar.dao.DashboardDAO;
import com.intranet_escolar.model.DTO.HijoDTO;
import com.intranet_escolar.service.ApoderadoService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.SQLException;
import java.util.*;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

public class ApoderadoServiceTest {
    
    private DashboardDAO mockDAO;
    private ApoderadoService service;

    @BeforeEach
    public void setUp() throws SQLException {
        mockDAO = mock(DashboardDAO.class);
        service = new ApoderadoService(mockDAO); // Constructor personalizado solo para pruebas
    }

    @Test
    public void testObtenerResumenHijo() throws SQLException {
        int idHijo = 1;
        HijoDTO mockHijo = new HijoDTO();
        mockHijo.setNombres("Juan");
        mockHijo.setApellidos("Pérez");

        when(mockDAO.obtenerResumenHijo(idHijo)).thenReturn(mockHijo);

        HijoDTO resultado = service.obtenerResumenHijo(idHijo);

        assertNotNull(resultado);
        assertEquals("Juan", resultado.getNombres());
        assertEquals("Pérez", resultado.getApellidos());
        verify(mockDAO).obtenerResumenHijo(idHijo);
    }

    @Test
    public void testObtenerPromedioBimestre() throws SQLException {
        int idHijo = 2;
        when(mockDAO.obtenerPromedioBimestreApoderado(idHijo)).thenReturn(15.4);

        double promedio = service.obtenerPromedioBimestre(idHijo);

        assertEquals(15.4, promedio, 0.01);
        verify(mockDAO).obtenerPromedioBimestreApoderado(idHijo);
    }
}





