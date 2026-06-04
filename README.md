# LBD2026 GRUPO08 
## TP2
Alumnos:
* Huarachi Jorge Facundo
* Russo Francisco Agustín

# Trabajo Práctico: Triggers y Procedimientos Almacenados

**Grupo 8:** HUARACHI, Jorge Facundo — RUSSO, Francisco Agustín

---

## 🛠️ Triggers
Implementar la lógica para llevar una **auditoría** para todos los apartados siguientes de las operaciones de:
1. Creación
2. Modificación
3. Borrado

> 📝 **Requisitos de la Auditoría:**
> Se deberá auditar el **tipo de operación** que se realizó (creación, borrado, modificación), el **usuario** que la hizo, la **fecha y hora** de la operación, la **máquina** desde donde se la hizo y **toda la información necesaria** para la auditoría (en el caso de las modificaciones, se deberán auditar tanto los *valores viejos* como los *nuevos*).

---

## 💾 Procedimientos Almacenados
Realizar (lo más eficientemente posible) los siguientes procedimientos almacenados, incluyendo el **control de errores lógicos y mensajes de error**:

4. **Creación** de un usuario.
5. **Modificación** de un usuario.
6. **Borrado** de un usuario.
7. **Búsqueda** de un usuario.
8. **Listado de productos más vendidos**, ordenados de mayor a menor cantidad. Incluir los que no tienen ninguna venta e incluir montos.
9. **Listar ventas por categoría:** Dada una categoría, listar todas sus ventas mostrando:
   * Nombre de la categoría
   * Subcategoría
   * Producto
   * Fecha comanda
   * Cantidad
   * Importes
   * _Todo debidamente ordenado._
10. Realizar un procedimiento almacenado con alguna **funcionalidad que considere de interés**.

---

## 📌 Observaciones

* 🚫 **Sentencias inválidas:** No incluir en el script sentencias que ejecuten procedimientos almacenados que no cumplan con lo solicitado.
* 📞 **Sentencias de llamada:** Incluir las sentencias de llamada a los procedimientos. Para cada uno, realizar **4 llamadas**:
  * `1` con salida correcta.
  * `3` con diferentes errores, explicando su intención mediante un comentario.
* 💬 **Mensajes de error:** En los apartados donde deban generarse mensajes, implementarlos usando **parámetros de salida**.
* ⚙️ **Diseño de la BD:** Si en el diseño de la BD hubiera cambios con respecto a lo presentado en los prácticos 1 y 2, incluirlos en el script. De igual forma en caso de necesitar más datos de prueba de los generados en el TP1.
* 📂 **Formato de entrega:** Respetar las mismas reglas de los TP1 y TP2 para los nombres de los archivos a subir al repositorio, como así también los comentarios en el encabezado dentro del script.

### Modelo Físico Relacional:
![Esquema de la base de datos](LBD2026G08TP2Diagrama.png)


### Índices:

| Tabla | Nombre del Índice | Tipo | Columna(s) Indexada(s) |
| :--- | :--- | :--- | :--- |
| **Categorias** | `categoria_UNIQUE` | UNIQUE | `categoria` |
| **Subcategorias** | `Subcategorias_subcategoria_idCategoria_UNIQUE` | UNIQUE | `idCategoria`, `subcategoria` |
| **Productos** | `idx_Productos_producto` | INDEX | `producto` |
| **Usuarios** | `email_UNIQUE` | UNIQUE | `email` |
| **Usuarios** | `dni_UNIQUE` | UNIQUE | `dni` |
| **Usuarios** | `username_UNIQUE` | UNIQUE | `username` |
| **Usuarios** | `idx_Usuarios_nombres_apellidos` | INDEX | `nombres`, `apellidos` |
| **Mesas** | `numeroMesa_UNIQUE` | UNIQUE | `numeroMesa` |
| **Comandas** | `idx_Comandas_fechaInicio` | INDEX | `fechaInicio` |
| **Comandas** | `idx_Comandas_fechaFin` | INDEX | `fechaFin` |
| **LineasComandas** | `idx_LineasComandas_idComanda_estado` | INDEX | `idComanda`, `estado` |
| **CuponesClientes** | `codigo_UNIQUE` | UNIQUE | `codigo` |