
# RP Score System

---

### **Description**

The RP Score System is designed for FiveM roleplay servers to track and manage players' RP scores dynamically. The RP score ranges from 'S' to 'E', starting at 'C' for every player. Staff members can increase or decrease scores as needed. Specific rules can also enforce penalties, such as banning players with an 'E' score automatically.

---

### **Features**

- **Dynamic RP Score Display**: Scores are visible in the pause menu, alongside the player’s ID.
- **Database Integration**: Stores and retrieves RP scores using an SQL database.
- **Automatic Penalties**: Automatically bans players with the lowest score ('E') and logs the ban in the database.
- **Custom Triggers**: Modify RP scores using server-side events.
- **Flexibility**: Predefined valid scores ('S', 'A', 'B', 'C', 'D', 'E') with color-coded visuals.

---

### **Installation Steps**

1. **Database Setup**:
   - Import the `rpscore.sql` file into your MySQL database.
   - Ensure the `users` table includes an `rp_score` column.

2. **Server Configuration**:
   - Add the following dependencies to your server resources:
     ```plaintext
     ensure es_extended
     ensure oxmysql
     ```

3. **Script Deployment**:
   - Place the `server.lua` and `client.lua` files in a new folder under your FiveM resources directory (e.g., `resources/[your_folder]/rpscore`).
   - Add the resource to your `server.cfg`:
     ```plaintext
     ensure rpscore
     ```

4. **Configure OxMySQL**:
   - Ensure OxMySQL is set up and working in your server environment. Update any database connection credentials in the `server.lua` script if needed.

---

### **Usage Example**

To modify a player's RP score, you can use the following server-side trigger:

```lua
TriggerEvent('rpscore:modify', playerServerId, newRPScore)
```

**Parameters**:
- `playerServerId` (integer): The server ID of the player.
- `newRPScore` (string): The new score to set (must be one of `'S', 'A', 'B', 'C', 'D', 'E'`).

**Example**:
```lua
TriggerEvent('rpscore:modify', 25, 'A') -- Sets player with server ID 25 to an RP score of 'A'.
```

Alternatively, you can call the trigger to set the score from the client side:

```lua
TriggerServerEvent('rp:setScore', 'B') -- Sets your own RP score to 'B'.
```

---

### **Preview**

The RP score is displayed dynamically in the pause menu as follows:
- Example: `YOUR SERVER NAME | RP Score : ~g~A ~w~| ID : ~b~25 ~w~| PLAYERS :`

---

### **Notes**

- Players with an RP score of 'E' will be banned for 48 hours automatically upon reaching the score.
- Modify the `BanPlayer` function in `server.lua` to customize ban reasons or durations.
- Ensure the pause menu updates instantly when changes are made by staff using triggers.

---

### **License**

This project is open source and can be modified as per your server’s needs. Make sure to credit the original developer if redistributing.
# RP-Score-
