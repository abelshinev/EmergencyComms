import axios from "axios";
import * as readline from "node:readline";
import payload from "./payload.js";

export async function requestButton() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    });

    rl.question("Press Enter to request assistance...", async () => {
        try {
            const res = await axios.post(
                "http://localhost:3000/emergency", payload
            );

            console.log(res.data);
        } catch (err) {
            console.error(err);
        }

        rl.close();
    });
}