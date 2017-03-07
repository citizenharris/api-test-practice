require 'faraday'
require 'json'

describe 'CRUD' do
url = 'http://lacedeamon.spartaglobal.com/todos'
  
  it 'should read the api and return a JSON' do
    response = Faraday.get(url)
    response = response.to_json
    expect(response).is_a? JSON
  end

  it 'should create a new todo' do
    response = Faraday.post(url, {title: 'wax moustache', due: '2017-09-09'})
    expect(response.status).to eq 201
  end

  it 'should return an error if supplied a date earlier than 1970-01-01' do
    response = Faraday.post(url, {title: 'wax moustache', due: '1967-09-09'})
    expect(response.status).to eq 405
  end

  it 'should return an error if supplied a date in the past' do
    response = Faraday.post(url, {title: 'wax moustache', due: '1987-09-09'})
    expect(response.status).to eq 405
  end

  it 'should be able to create a todo with a duplicate title' do
    response = Faraday.post(url, {title: 'wax moustache', due: '2017-09-09'})
    response = Faraday.post(url, {title: 'wax moustache', due: '2027-09-09'})
    expect(response.status).to eq 201
  end

  it 'should delete a todo when given a delete request' do
    resp = Faraday.post(url, {title: 'wax moustache', due: '1987-09-09'})
    resp = JSON.parse(resp.body)
    resp = resp['id']
    resp = Faraday.delete('http://lacedeamon.spartaglobal.com/todos/#{resp}')
    expect(resp.status).to eq 204
  end

  it 'should edit a todo' do
    rp = Faraday.post(url, {title: 'wax moustache', due: '2987-09-09'})
    rp = JSON.parse(rp.body)
    rp = rp['id']
    rp = Faraday.put('http://lacedeamon.spartaglobal.com/todos/#{rp}', {title: 'wax moustache fiercely', due: '2017-09-09'})
    rp = JSON.parse(rp.body)
    expect(rp['title']).to eq 'wax moustache fiercely'
  end
end

