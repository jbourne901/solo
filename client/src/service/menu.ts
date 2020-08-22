import {IServiceResultWithPayload} from "./service-result";
import { ICancellableTransportPromise } from "../framework/transport";
import { ICommonService, CommonService } from "./common-service";
import IMenu from "../model/menu";

export type IMenuListResult = IServiceResultWithPayload<IMenu[]>;

export interface IEPageService extends ICommonService {
    menuList(): ICancellableTransportPromise<IMenuListResult>;
}

export interface IMenuService extends ICommonService {
    menuList(name: string): ICancellableTransportPromise<IMenuListResult>;
}    

export class MenuService extends CommonService implements IMenuService {
    private readonly BASE_URL: string;
    constructor() {
        super();
        this.BASE_URL=process.env.REACT_APP_API_URL + "/menu";
    }

    public menuList(name: string): ICancellableTransportPromise<IMenuListResult> {
        const url = this.BASE_URL+"/list";

        return this.postWithSession<IMenuListResult>(url, {name});
    }
}

