import { EventFragment, Interface, Result } from 'ethers/lib/utils';

export class WarpInterface {
  ethersInterface: Interface;
  decodeEventLog(eventFragment: EventFragment | string, data: string, topics: string[]): Result {
    return this.ethersInterface.decodeEventLog(eventFragment, data, topics);
  }
  encodeEventLog(
    eventFragment: EventFragment | string,
    values: any[],
  ): { data: string; topics: Array<string> } {
    return this.ethersInterface.encodeEventLog(eventFragment, values);
  }
  constructor(events: EventFragment | string) {
    if (events instanceof EventFragment) {
      this.ethersInterface = new Interface([events]);
      return;
    }
    this.ethersInterface = new Interface(events);
  }
}
