// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers, TestWithExecutor} from '../GovHelpers.sol';
import {AaveMisc} from 'aave-address-book/AaveMisc.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {PayloadWithEmit} from './mocks/PayloadWithEmit.sol';

contract GovernanceTest is Test {
  function setUp() public {
    vm.createSelectFork('mainnet', 16526807);
  }

  function testCreateProposal() public {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](2);
    payloads[0] = GovHelpers.buildMainnet(address(1));
    payloads[1] = GovHelpers.buildPolygon(address(2));

    vm.startPrank(AaveMisc.ECOSYSTEM_RESERVE);
    GovHelpers.createProposal(payloads, bytes32('ipfs'));
    vm.stopPrank();
  }
}

contract GovernanceL2ExecutorTest is Test {
  event TestEvent();

  function setUp() public {
    vm.createSelectFork('polygon', 43322560);
  }

  function testCreateProposal() public {
    PayloadWithEmit payload = new PayloadWithEmit();
    vm.expectEmit(true, true, true, true);
    emit TestEvent();
    GovHelpers.executePayload(vm, address(payload));
  }
}

contract GovernanceMainnetExecutorTest is Test {
  event TestEvent();

  function setUp() public {
    vm.createSelectFork('mainnet', 17370904);
  }

  function testCreateProposal() public {
    PayloadWithEmit payload = new PayloadWithEmit();
    vm.expectEmit(true, true, true, true);
    emit TestEvent();
    GovHelpers.executePayload(vm, address(payload), AaveGovernanceV2.SHORT_EXECUTOR);
  }
}
