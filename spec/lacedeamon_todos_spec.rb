require 'httparty'

describe 'CRUD' do

  it 'should read the api and return a JSON' do
    response = HTTParty.get('http://lacedeamon.spartaglobal.com/todos')
    expect(response).is_a? JSON
  end

  it 'should create a new todo' do
    response = HTTParty.post('http://lacedeamon.spartaglobal.com/todos', {title == 'wax moustache', due == '2017-09-09'})
    expect(response).to have_http_status(201)
  end

end