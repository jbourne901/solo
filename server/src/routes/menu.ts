import express, {Request, Response, NextFunction} from "express";
import MenuController from "../controller/menu";
import BowRouter from "./bow-router";
import BowLog from "../framework/bow-log";

export default class MenuRouter extends BowRouter {
    public static getRouter() {
        const myself = this.getMyself("getRouter");
        BowLog.log1(myself, "getRouter()");
        const router = express.Router();

        router.post("/list", (req: Request, res: Response, next: NextFunction) => {
            BowLog.log1(myself, "POST /api/menu/list");
            return MenuController.menuList(req, res, next);
        });

        return router;
    }

    protected static getClassName() {
        return "MenuRouter";
    }
}
