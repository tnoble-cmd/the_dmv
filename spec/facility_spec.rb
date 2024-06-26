require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility).to be_an_instance_of(Facility)
      expect(@facility.name).to eq('DMV Tremont Branch')
      expect(@facility.address).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
      expect(@facility.phone).to eq('(720) 865-4600')
      expect(@facility.services).to eq([])
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility.services).to eq([])
      @facility.add_service('New Drivers License')
      @facility.add_service('Renew Drivers License')
      @facility.add_service('Vehicle Registration')
      expect(@facility.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end

  describe '#register_vehicle' do
    it 'can register a vehicle' do
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice})
      expect(@facility.register_vehicles).to eq([])
      @facility.register_vehicle(cruz)
      expect(@facility.register_vehicles.length).to eq(1)
      expect(@facility.register_vehicles[0].vin).to eq('123456789abcdefgh')
    end
  end

  describe '#calculate_fee' do
    it 'can calculate the fee for a vehicle' do
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice})
      @facility.register_vehicle(cruz)
      expect(@facility.register_vehicles.length).to eq(1)
      expect(@facility.collected_fees).to eq(0)
      @facility.calculate_fee(cruz)
      expect(@facility.collected_fees).to eq(100)
    end

    it 'can calculate the fee for an electric vehicle' do
      bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev})
      @facility.register_vehicle(bolt)
      expect(@facility.register_vehicles.length).to eq(1)
      expect(@facility.collected_fees).to eq(0)
      @facility.calculate_fee(bolt)
      expect(@facility.collected_fees).to eq(200)
    end

    it 'can calculate the fee for an antique vehicle' do
      camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice})
      @facility.register_vehicle(camaro)
      expect(@facility.register_vehicles.length).to eq(1)
      expect(@facility.collected_fees).to eq(0)
      @facility.calculate_fee(camaro)
      expect(@facility.collected_fees).to eq(25)
    end
  end

  describe '#administer_written_test' do
    it 'can administer a written test' do
      registrant = Registrant.new('Bill', 25, true)
      expect(@facility.services).to eq([])
      expect(registrant.license_data[:written]).to eq(false)
      @facility.add_service('Written Test')
      @facility.administer_written_test(registrant)
      expect(registrant.license_data[:written]).to eq(true)
    end

    it 'can not administer a written test because services' do
      registrant = Registrant.new('Bill', 25, true)
      expect(@facility.services).to eq([])
      expect(registrant.license_data[:written]).to eq(false)
      expect(@facility.administer_written_test(registrant)).to eq('This facility does not offer written tests.')
    end

    it 'does not administer a written test because age' do
      registrant = Registrant.new('Will', 15)
      expect(@facility.services).to eq([])
      @facility.add_service('Written Test')
      @facility.administer_written_test(registrant)
      expect(registrant.license_data[:written]).to eq(false)
      expect(@facility.administer_written_test(registrant)).to eq('Registrant is too young to take the written test.')
    end

    it 'does not administer a written test because permit' do
      registrant = Registrant.new('Bill', 15)
      expect(@facility.services).to eq([])
      @facility.add_service('Written Test')
      @facility.administer_written_test(registrant)
      expect(registrant.license_data[:written]).to eq(false)
      expect(@facility.administer_written_test(registrant)).to eq('Registrant is too young to take the written test.')
    end
  end
  
  describe '#administer_road_test' do
    it 'can administer a road test' do
      registrant = Registrant.new('Bill', 25, true)
      expect(@facility.services).to eq([])
      expect(registrant.license_data[:written]).to eq(false)
      @facility.add_service('Written Test')
      @facility.administer_written_test(registrant)
      expect(registrant.license_data[:written]).to eq(true)
      @facility.add_service('Road Test')
      @facility.administer_road_test(registrant)
      expect(registrant.license_data[:license]).to eq(true)
    end

    it 'facility does not offer road test' do
      registrant = Registrant.new('Bill', 25, true)
      expect(@facility.services).to eq([])
      @facility.administer_road_test(registrant)
      expect(@facility.administer_road_test(registrant)).to eq('This facility does not offer road tests.')
    end
  end

  describe '#renew_drivers_license'
    it 'can renew drivers license' do
      registrant = Registrant.new('Bill', 25, true)
      expect(@facility.services).to eq([])
      expect(registrant.license_data[:written]).to eq(false)
      @facility.add_service('Written Test')
      @facility.administer_written_test(registrant)
      expect(registrant.license_data[:written]).to eq(true)
      @facility.add_service('Road Test')
      @facility.administer_road_test(registrant)
      expect(registrant.license_data[:license]).to eq(true)
      @facility.add_service('Renew License')
      @facility.renew_drivers_license(registrant)
      expect(registrant.license_data[:renew]).to eq(true)
    end
  
    it 'can not renew drivers license' do
      registrant = Registrant.new('Bill', 25, true)
      expect(@facility.services).to eq([])
      @facility.add_service('Written Test')
      @facility.add_service('Road Test')
      @facility.administer_written_test(registrant)
      @facility.administer_road_test(registrant)
      @facility.renew_drivers_license(registrant)
      expect(@facility.renew_drivers_license(registrant)).to eq('This facility does not offer road tests.')
    end
end
