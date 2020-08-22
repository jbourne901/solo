import React from 'react';
import Service from "../../service";
import {ILocalizationService, ILocalizationLocal} from "../../service/localization";
import {withLanguageListener, ILanguageProps } from '../with-language-listener';
import { ILanguageInfo } from '../../model/language';

interface IProps extends ILanguageProps {
}

interface IState {
    language?: ILanguageInfo;
}

class LandingInternal extends React.Component<IProps, IState> {
    localizationSvc: ILocalizationService;
    local: ILocalizationLocal;

    private static readonly LOCALIZATION_KEY = "landingpage";

    public static getDerivedStateFromProps(props: IProps, state: IState) {
        return {
            language: props.language
        };
    }

    constructor(props: IProps) {
        super(props);
        this.localizationSvc = Service.localization();
        this.local = this.localizationSvc.local(LandingInternal.LOCALIZATION_KEY);

        this.state = {
            language: props.language
        };
    }

    public render() {
        const selectMenuMessage = this.local("selectMenuMessage") || "Select menu option";
        return (
           <div>
              {selectMenuMessage}
          </div>
        );
    }
}

const Landing = withLanguageListener(LandingInternal);
export default Landing;
