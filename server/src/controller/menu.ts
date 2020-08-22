import {Request, Response, NextFunction} from "express";
import {MenuRepository, IMenu} from "../model/menu";
import Controller from "./controller";
import BowLog from "../framework/bow-log";

export default class MenuController extends Controller {

    public static async menuList(req: Request, res: Response, next: NextFunction) {
        const myself = MenuController.getMyself("menuList");
        const session = req.body.session;
        const name = req.body.name;
        BowLog.log1(myself, "POST /api/menu/list name="+name+" session=");
        BowLog.dir(myself, session);
        return MenuRepository.menuList(name, session)
                             .then( (menus: IMenu[]) =>
                                     { 
                                         BowLog.log2(myself, `menuList menus = `)
                                         BowLog.dir(myself, menus)
                                         Controller.sendSuccessWithPayload(menus, req, res, next);
                                     }
                                  )
                             .catch( (err: any) => this.processError(err, req, res, next) );
    }

    protected static getClassName() {
        return "MenuController";
    }
}
