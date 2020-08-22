import BowLog from "../framework/bow-log";
import Loggable from "../framework/loggable";
import DB from "../db";
import {IQueryResultWithPayload} from "./model";
import ISession from "./session";

export interface IMenu {
    id: string;
    name: string;
    epage_id?: string;
    url?: string;
    items: IMenu[];
}

export class MenuRepository extends Loggable {

    public static async menuList(name: string, session: ISession) {
        const myself = this.getMyself("menuList");
        BowLog.log1(myself, "name="+name+" session=");
        BowLog.dir(myself, session);

        const query = "select * from MenuListJSON($1, $2) res";
        const queryRes = await DB.db().one<IQueryResultWithPayload<IMenu[]>>(query, [name, session]);

        BowLog.log3(myself, "queryRes=");
        BowLog.dir(myself, queryRes);
        const res = queryRes.res || queryRes;

        if (res.result === "OK") {
            return res.payload;
        }
        throw(res);
    }
    protected static getClassname() {
        return "MenuRepository";
    }
}

