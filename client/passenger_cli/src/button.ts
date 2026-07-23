import axios from "axios";
import * as readline from "node:readline";

export async function requestButton() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    });

    rl.question("Press Enter to request assistance...", async () => {
        try {
            const res = await axios.post(
                "http://localhost:3000/emergency",
                {
                    deviceId: "DEV001",
                }
            );

            console.log(res.data);
        } catch (err) {
            console.error(err);
        }

        rl.close();
    });
}