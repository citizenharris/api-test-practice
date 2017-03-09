require 'httparty'
require 'json'

describe 'Lacedeamon API' do
url = 'http://lacedeamon.spartaglobal.com/todos'

@todos = []
def call_api(method, path, params={})
  rp = HTTParty.send(method) 'http://lacedeamon.spartaglobal.com/todos', query: params
  @todos << r['id']
  return rp
end

def delete_all
  @todos.each do |id|
  call_api :delete, "/#{id}"
  end
end
  
  it 'should read the api and return a JSON' do
    call_api :get, '/'
    expect(r).is_a? JSON
  end

  it 'should create a new todo' do
    call_api :post '/' title: 'wax moustache', due: '2017-09-09'
    expect(response.code).to eq 201
  end

  it 'should return an error if supplied a date earlier than 1970-01-01' do
    call_api :post '/' title: 'wax moustache', due: '1967-09-09'
    expect(response.code).to eq 405
  end

  it 'should return an error if supplied a date in the past' do
    call_api :post '/' title: 'wax moustache', due: '1987-09-09'
    expect(response.code).to eq 405
  end

  it 'should be able to create a todo with a duplicate title' do
    call_api :post '/' title: 'wax moustache', due: '2017-09-09'
    call_api :post '/' title: 'wax moustache', due: '2027-09-09'
    expect(response.code).to eq 201
  end

  it 'should delete a todo when given a delete request' do
    call_api :post '/' title: 'wax moustache', due: '1987-09-09'
    resp = JSON.parse(rp.body)
    resp = resp['id']
    call_api :delete "/#{resp}"
    expect(resp.code).to eq 204
  end

  it 'should overwrite a todo' do
    call_api :post '/' title: 'wax moustache', due: '2987-09-09'
    resp = JSON.parse(rp.body)
    resp = resp['id']
    call_api :put "/#{resp}", title: 'wax moustache fiercely', due: '2017-09-09'
    resp = JSON.parse(resp.body)
    expect(resp['title']).to eq 'wax moustache fiercely'
    # && expect(resp['due']).to eq '2017-09-09'
  end

  it 'should edit a todo' do
    call_api :post '/' title: 'oil beard', due: '2987-09-09'
    resp = JSON.parse(rp.body)
    resp = resp['id']
    call_api :patch "/#{resp}", title: 'oil beard fiercely'
    resp = JSON.parse(resp.body)
    expect(resp['title']).to eq 'oil beard fiercely'
  end

  it 'should not accept a word as a valid date format' do
    call_api :post '/' title: 'wax moustache', due: 'bananarama'
    expect(response.code).to eq 500
  end

  it 'should not accept American date format as a valid date format' do
    call_api :post '/' title: 'wax moustache', due: '12-24-1978'
    expect(response.code).to eq 500

  it 'should only accept a variant of yyyy-mm-dd as a valid date format' do
    call_api :post '/' title: 'wax moustache', due: '99-09-09'
    expect(response.code).to eq 405
  end
  end
end

