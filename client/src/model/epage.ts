export interface IEPageInfo {
    id: string;
    label: string;
    name: string;
    type: string;
    url: string;
    entity: string;
};


export interface IEPageAction {
    id: string;
    name: string;
    label: string;
    type: string;
    isitemaction: boolean;
    query: string;
    confirm: string;
    location: string;
    style: string;
}

export interface IEPageField {
    name: string;
    label: string;
    type: string;
    tab: string;
    queryTag?: string;
}

export interface IETabbedFields {
    [name: string]: IEPageField[];
}

export interface IEPageSelectionLists {
    [listName: string]: any[];
}

export interface IEPage {
    id: string;
    name: string;
    label: string;
    lists: IEPageSelectionLists;
    pkname: string;
    fields: IEPageField[];
    pageactions: IEPageAction[];
    entity: string;
};

export const IEPageDefault: IEPage = {
    id: "",
    name: "",
    label: "",
    pkname: "",
    fields: [],
    pageactions: [],
    entity: "",
    lists: {}
};

